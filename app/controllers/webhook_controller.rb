class WebhookController < ApplicationController
  require 'line/bot'
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
            case event['message']['text']
            when "exit"
              session.delete(:selectbook)
              session.delete(:bookinfo)
              session.delete(:userinfo)
              message = {type:'text',
                          text:"終了しました"
                }
                client.reply_message(event['replyToken'], message)
            when "メモする"
              session.delete(:selectbook)
              session.delete(:bookinfo)
              session.delete(:userinfo)
                user_id = event['source']['userId']
                if User.where(uid:user_id).exists? #ユーザー登録済みチェック
                  booktitle = book_select(user_id)
                  unless booktitle == "" #本の登録チェック
                    session[:title] = booktitle
                    message = {
                            "type": "flex",
                            "altText": "this is a flex message",
                            "contents": {
                              "type": "bubble",
                              "header": {
                                "type": "box",
                                "layout": "vertical",
                                "contents": [
                                  {
                                    "type": "text",
                                    "text": "タップして本を選択してください。"
                                  }
                                ]
                              },
                              "body": {
                                "type": "box",
                                "layout": "vertical",
                                "contents": booktitle
                              }
                            }
                          }
                  else
                    reply = "本が一件も登録されていません。\n本の登録をお願いします！"
                    message = {type:'text',
                              text:reply}
                  end
                else
                  reply = "ご利用ありがとうございます！\nユーザー登録をお願いいたします。\nhttps://botdememo.herokuapp.com"
                  message = {type:'text',
                              text:reply}
                end
                  client.reply_message(event['replyToken'], message)
             else
                if session[:selectbook].present?
                  @selectbook = session[:selectbook]
                  @userinfo = session[:userinfo]
                  memo = event['message']['text']
                  begin
                    Memo.create!(body:memo,book_id:@selectbook["id"],user_id:@userinfo[0]["id"])
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
                elsif session[:bookinfo].present?
                  book_id = event['message']['text'].to_i
                  session[:selectbook] = session[:bookinfo][book_id -1]
                  message = {type:'text',
                        text:"★本を選択しました!★\n#{session[:selectbook]["title"]}"}
                  client.reply_message(event['replyToken'], message)
                end
            end
           end
         end
      }
    head :ok
  end

  def book_select(user_id)
    session[:userinfo] = User.where(uid:user_id)
    @books = BookShelf.where(user_id:session[:userinfo].ids)
    bookinfo = []
    @books.each do |book|
      bookinfo << book.book
      session[:bookinfo] = bookinfo
    end
      booktitle = bookinfo.map.with_index{|a, index| {
                                                        "type": "button",
                                                        "style": "link",
                                                        "height": "sm",
                                                        "action": {
                                                          "type":"message",
                                                          "label":"#{index + 1} : #{a.title}",
                                                          "text": "#{index + 1}"
                                                          },
                                                          "flex": 7
                                                      }
                                                        }
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_BOT_SECRET']
      config.channel_token = ENV['LINE_BOT_KEY']
    }
  end
end
