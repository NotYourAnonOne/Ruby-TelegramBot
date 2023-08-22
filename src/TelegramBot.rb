# Copyright (c) [2023] NotYourAnonOne

require 'telegram/bot'
require 'teleglass'

# Replace 'YOUR_API_TOKEN' with your actual bot API token
token = 'YOUR_API_TOKEN'

# Define the channel ID that users need to join
required_channel_id = '@your_channel_username'

# Store user IDs who have joined the channel
joined_users = []

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user_id = message.from.id

    if !joined_users.include?(user_id) && !user_joined_channel?(bot, user_id, required_channel_id)
      ask_to_join_channel(bot, message.chat.id)
    else
      case message.text
      when '/start'
        send_welcome_message(bot, message.chat.id)
      when '/help'
        send_help_message(bot, message.chat.id)
      when '/about'
        send_about_message(bot, message.chat.id)
      else
        send_default_response(bot, message.chat.id)
      end
    end
  end
end

def user_joined_channel?(bot, user_id, channel_id)
  member = bot.api.get_chat_member(chat_id: channel_id, user_id: user_id)
  member && member['status'] == 'member'
end

def ask_to_join_channel(bot, chat_id)
  response = "👋 To use this bot, please join our channel first. Click the button below to join:"

  keyboard = Teleglass::InlineKeyboardMarkup.new do
    add Teleglass::InlineKeyboardButton.new(text: 'Join Channel', url: 'https://t.me/your_channel_username')
  end

  bot.api.send_message(chat_id: chat_id, text: response, reply_markup: keyboard)
end

def send_welcome_message(bot, chat_id)
  response = "🌟 Welcome to our professional Telegram bot! How can I assist you today?"
  bot.api.send_message(chat_id: chat_id, text: response)
end

def send_help_message(bot, chat_id)
  response = "🔍 Welcome to the help section:\n\n- Use /start to begin.\n- Use /about to learn more about me.\n- Use /help to see this message again."
  bot.api.send_message(chat_id: chat_id, text: response)
end

def send_about_message(bot, chat_id)
  response = "🤖 I am a professional Telegram bot designed to provide information and assistance. Feel free to interact with me!"
  bot.api.send_message(chat_id: chat_id, text: response)
end

def send_default_response(bot, chat_id)
  response = "🤔 I'm sorry, I couldn't understand your request. Type /help to see available commands."
  bot.api.send_message(chat_id: chat_id, text: response)
end
