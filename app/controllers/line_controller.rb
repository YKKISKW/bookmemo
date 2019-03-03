require'line/bot'

class LineController < ApplicationController
  protect_from_forgery:except=>[:bot]

  def bot
    body = request.body.read
    binding.pry
    signature=request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body,signature)
      head:bad_request
  end

  events = client.parse_events_from(body)
  events.each{|event|
    case event
      when Line::Bot::Event::Message
        case event.type
          when Line::Bot::Event::MessageType::Text
            content = event['message']['text']
              begin
                Memo.create!(body:content)
                  message = {type:'text',text:"メモ『#{content}』を登録しました！"}
                  client.reply_message(event['replyToken'],message)
              end
        end
    end
  }
  head:ok
end

private

  def client
    @client||=Line::Bot::Client.new{|config|
    #サーバに事前に登録したチャネルシークレットとチャネルトークンをセット
    config.channel_secret=ENV["LINE_CHANNEL_SECRET"]config.channel_token=ENV["LINE_CHANNEL_TOKEN"]}
  end
end
