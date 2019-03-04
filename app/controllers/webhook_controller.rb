require 'line/bot'

class WebhookController < ApplicationController
   protect_from_forgery except: :callback

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          memo = event['message']['text']
            begin
              Memo.create!(body:memo)
              message = {type:'text',
                        text:"メモ『#{memo}』を登録しました！"
              }
              client.reply_message(event['replyToken'], message)
            rescue
              message = {type:'text',
                        text:"メモ『#{memo}』の登録に失敗しました"
              }
              client.reply_message(event['replyToken'], message)
            end
         end
       end
    }

    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "9516efa927e823747e046062ded27112"
      config.channel_token = "Q/7mQd+eyZnmrpwHuI9sSXJLPkMq3HCR4zblIGhpto6ryPlghn6M32OBciTdnzjeBLPve+/Mn3ME2YtiAKetGdKxuFYRu9O+ifyrjud58l9v2777Czy+fgVESdxeAHLYObXYk3WMp47OZQ3TmCxUCwdB04t89/1O/w1cDnyilFU="
    }
  end
end
