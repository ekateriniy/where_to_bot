Telegram.bots_config = {
  default: Rails.application.credentials[:telegram][:bot][:token] }

# Telegram.bot.get_updates
Telegram.bot == Telegram.bots[:default]
