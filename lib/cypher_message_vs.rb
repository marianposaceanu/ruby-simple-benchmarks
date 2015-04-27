require 'openssl'
require 'benchmark'
require 'active_support'

module BfThinLayer
  class CryptStore
    SALT = "\r\xFD\xF8L\xDD3\xB4V\xC8,\ei;`\xBB6\n\x82'\x024\x1D\xD9\x05\xFD\xC3\x8F\x89'S\xB6\xA2\f\a\xD4\xF2;\xD8p\xC7\xE6\n7[R\x87\xDB,\x03P\x7F\x10\n0kf%\r\xC4\x1A\xA0c\x92\x9B"

    class << self
      attr_accessor :cipher

      def load(value)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        crypt.decrypt_and_verify(value)
      end

      def dump(value)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        crypt.encrypt_and_sign(value)
      end

      private

      def message_encryptor
        @encryptor = ActiveSupport::MessageEncryptor.new(key, cipher: @cipher)
      end

      def key
        secret_token = 'this-is-a-secret'
        key = ActiveSupport::KeyGenerator.new(secret_token).generate_key(SALT)
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

n = 500000

Benchmark.bm do |x|
  x.report('AES CBC 256') do
    data = Marshal.dump(raw_data)

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

  x.report('seed') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher = 'seed'
    BfThinLayer::CryptStore.dump(data)
  end
end
