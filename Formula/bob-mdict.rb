# typed: strict
# frozen_string_literal: true

# Local loopback service used by the MDict Bob plugin.
class BobMdict < Formula
  desc "Local MDict dictionary service for the Bob MDict plugin"
  homepage "https://github.com/wakewon/bob-plugin-mdict"
  version "1.1.0"
  license "GPL-3.0-or-later"

  depends_on "speex"

  on_macos do
    on_arm do
      url "https://github.com/wakewon/bob-plugin-mdict/releases/download/v#{version}/bob-mdict-#{version}-darwin-arm64.tar.gz"
      sha256 "0d2fb93211409019cb90238cec9a21e84397b62754dd258a5b155a6327455967"
    end
    on_intel do
      url "https://github.com/wakewon/bob-plugin-mdict/releases/download/v#{version}/bob-mdict-#{version}-darwin-amd64.tar.gz"
      sha256 "22a01ca3a95b74e13d9299f149a86fe9404fce696033284769b500b19539d33c"
    end
  end

  def install
    bin.install "bob-mdict"
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"bob-mdict"]
    keep_alive successful_exit: false
    log_path var/"log/bob-mdict.log"
    error_log_path var/"log/bob-mdict.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      bob-mdict reads dictionaries you supply. It ships no dictionary data.

      Put each dictionary in its own folder under:
        ~/Library/Application Support/bob-mdict/dictionaries/

      Then run:
        brew services start bob-mdict
        bob-mdict --check
    EOS
  end

  test do
    identity = shell_output("#{bin}/bob-mdict --version")
    assert_match "bob-mdict #{version}", identity
    assert_match "api=v2", identity
  end
end
