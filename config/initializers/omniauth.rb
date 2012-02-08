Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '232648703490156', '2d4a909fe1621011d9ed0bdc07a11a81'
end
