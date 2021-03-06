module Denounces
  class CreateService
    attr_reader :denounce
    def initialize(params, author, town)
      @params = params
      @author = author
      @town = town
    end

    def call
      @denounce = @town.denounces.build(@params)
      @denounce.author_user = @author

      if @denounce.save
        ping_slack unless Rails.env.test?
        true
      else
        false
      end
    end

    private

    def connect_slack
      channel_url = "https://hooks.slack.com/services/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"
      Slack::Notifier.new channel_url do
        defaults channel: "#general",
                 username: "denouncer"
      end
    end

    def ping_slack
      author_slack_name = @author.decorate.author_slack_name(@denounce.id)
      denounced_user_nick = @denounce.denounced_user.decorate.nick_or_name
      connect_slack.ping "<!channel> <#{author_slack_name}> denounced: <#{denounced_user_nick}> for: #{@denounce.content}"
    end
  end
end
