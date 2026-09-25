# typed: strict
# frozen_string_literal: true

# Local loopback service used by the MDict Bob plugin.
class BobMdict < Formula
  desc "Local MDict dictionary service for the Bob MDict plugin"
  homepage "https://github.com/wakewon/bob-plugin-mdict"
  version "1.3.0"
  license "GPL-3.0-or-later"

  depends_on "speex"

  on_macos do
    on_arm do
      url "https://github.com/wakewon/bob-plugin-mdict/releases/download/v#{version}/bob-mdict-#{version}-darwin-arm64.tar.gz"
      sha256 "80efec7fe738b14e36b5e554fa244415413cbb42085eea0172342cff0b5699c7"
    end
    on_intel do
      url "https://github.com/wakewon/bob-plugin-mdict/releases/download/v#{version}/bob-mdict-#{version}-darwin-amd64.tar.gz"
      sha256 "b0b3ed53f46f06a85af0c34a4ba9f4b671e51bfd77bf43bb6457a3fc678e6b92"
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
