require 'openssl'
require 'benchmark'
require 'active_support'

module BfThinLayer
  class CryptStore
    SECRET_KEY = "x" * 64 
    SALT       = "\r\xFD\xF8L\xDD3\xB4V\xC8,\ei;`\xBB6\n\x82'\x024\x1D\xD9\x05\xFD\xC3\x8F\x89"
    KEY        = ActiveSupport::KeyGenerator.new(SECRET_KEY).generate_key(SALT).freeze

    class << self
      attr_accessor :cipher

      def load(value)
        message_encryptor.decrypt_and_verify(value)
      end

      def dump(value)
        message_encryptor.encrypt_and_sign(value)
      end

      private

      def message_encryptor
        @encryptor = ActiveSupport::MessageEncryptor.new(KEY, cipher: @cipher)
      end
    end
  end
end

raw_data = {
  session_id: '99e14c789176e416d777c5170f7e0c0f',
  token: '43AA14F7-9B2A-4B17-963A-7D18825D1193',
  lang: 'de',
  other_info: [1,2,3,4]
}

data = Marshal.dump(raw_data)

n = 500000

Benchmark.bmbm(10) do |x|
  x.report('AES CBC 256') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-256-CBC'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES CBC 256 no-M') do
    BfThinLayer::CryptStore.cipher = 'AES-256-CBC'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES ECB 256') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-256-ECB'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES CBC 128') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-128-CBC'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES CTR 128') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-128-CTR'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES CTR 256') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-256-CTR'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES CFB 256') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-256-CFB'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES OFB 256') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'AES-256-OFB'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('rc4') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'rc4'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('rc4 no-M') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'rc4'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('rc4-40') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'rc4-40'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('rc4hmac-md5') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'rc4-hmac-md5'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('bf') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'bf'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('bf no-M') do
    BfThinLayer::CryptStore.cipher = 'bf'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('seed') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'seed'
    BfThinLayer::CryptStore.dump(data)
  end
end
