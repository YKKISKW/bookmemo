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

            case event['message']['text']
             when "exit"
              puts "*****  exit  ***********"
              session.delete(:selectbook)
              session.delete(:bookinfo)
              session.delete(:userinfo)
              message = {type:'text',
                          text:"終了しました"
                }
              puts "メッセージ  #{message}"
                client.reply_message(event['replyToken'], message)
            end
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
              session[:selectbook] = session[:bookinfo][book_id]
              message = {type:'text',
                    text:"本を選択しました\n#{session[:selectbook]["title"]}"}
              client.reply_message(event['replyToken'], message)
            end


            case event['message']['text']
            when "0"
              user_id = event['source']['userId']
              booktitle = book_select(user_id)
              session[:title] = booktitle
              message = {type:'text',
                    text:"本を選択してください\n#{booktitle}"}
              client.reply_message(event['replyToken'], message)
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
      booktitle = bookinfo.map.with_index{|a, index| "#{index} : #{a.title}"}.join("\n")
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_BOT_SECRET']
      config.channel_token = ENV['LINE_BOT_KEY']
    }
  end
end
