Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'CeukRxT8vopALfdYPFxdvA', 'cnEK4FO7bVWGskThUrTjtjtZVSsKNhkscUVMmT0V5o'
  provider :facebook, '199787513462177','7b960b19b1af7c9dd0b7df27a04e9eda'
end