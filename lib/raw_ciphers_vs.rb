require 'openssl'
require 'benchmark'

module BfThinLayer
  class CryptStore
    class << self
      SALT = "\r\xFD\xF8L\xDD3\xB4V\xC8,\ei;`\xBB6\n\x82'\x024\x1D\xD9\x05\xFD\xC3\x8F\x89'S\xB6\xA2\f\a\xD4\xF2;\xD8p\xC7\xE6\n7[R\x87\xDB,\x03P\x7F\x10\n0kf%\r\xC4\x1A\xA0c\x92\x9B"

      attr_accessor :cipher_algorithm

      def load(value)
        cipher.decrypt

        cipher.update(value) + cipher.final
      end

      def dump(value)
        cipher.encrypt

        cipher.update(value) + cipher.final
      end

      private

      def cipher
        @cipher_algorithm ||= 'aes-256-cbc'
        @cipher_digest    ||= OpenSSL::Cipher.new(@cipher_algorithm)
        @cipher_digest.key  = key
        @cipher_digest.iv   = SALT
        @cipher_digest
      end

      def key
        'this-is-a-secret'
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

Benchmark.bmbm(10) do |x|
  x.report('AES CBC 128') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.cipher_algorithm = 'aes-128-cbc'
    BfThinLayer::CryptStore.dump(data)
  end

  x.report('AES CBC 256') do
    data = Marshal.dump(raw_data)

    BfThinLayer::CryptStore.dump(data)
  end
end
