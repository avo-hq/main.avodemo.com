# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn,
  # The `_meta` object MCP clients attach to each call; ChatGPT fills it with the
  # end user's coarse location. avo-mcp_server filters the OAuth credentials itself.
  :_meta
]
