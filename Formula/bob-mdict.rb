# typed: strict
# frozen_string_literal: true

# Local loopback service used by the MDict Bob plugin.
class BobMdict < Formula
  desc "Local MDict dictionary service for the Bob MDict plugin"
  homepage "https://github.com/wakewon/bob-plugin-mdict"
  version "1.0.0"
  license "GPL-3.0-or-later"

  depends_on "speex"

  on_macos do
    on_arm do
      url "https://github.com/wakewon/bob-plugin-mdict/releases/download/v#{version}/bob-mdict-#{version}-darwin-arm64.tar.gz"
      sha256 "3b8d38e654dd986410dee6f2602a740c311936dec0f2880a435b60493599d003"
    end
    on_intel do
      url "https://github.com/wakewon/bob-plugin-mdict/releases/download/v#{version}/bob-mdict-#{version}-darwin-amd64.tar.gz"
      sha256 "603b5b1a6efd1fdbc0dc61cffc3bb871e6246017e513a1d3cbb63e68b5e148db"
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
