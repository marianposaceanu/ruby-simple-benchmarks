require 'openssl'
require 'benchmark'

raw_data = {
  session_id: '99e14c789176e416d777c5170f7e0c0f',
  token: '43AA14F7-9B2A-4B17-963A-7D18825D1193',
  lang: 'de',
  other_info: [1,2,3,4]
}


n = 500000

Benchmark.bm do |x|
  x.report('AES CBC 128') do
    data = Marshal.dump(raw_data)

    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv

    encrypted = cipher.update(data) + cipher.final
  end

  x.report('AES CBC 256') do
    data = Marshal.dump(raw_data)

    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv

    encrypted = cipher.update(data) + cipher.final
  end  
end
