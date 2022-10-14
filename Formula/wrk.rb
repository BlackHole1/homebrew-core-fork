class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.2.0.tar.gz"
  sha256 "e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad"
  # License is modified Apache 2.0 with addition to Section 4 Redistribution:
  #
  # (e) If the Derivative Work includes substantial changes to features
  #     or functionality of the Work, then you must remove the name of
  #     the Work, and any derivation thereof, from all copies that you
  #     distribute, whether in Source or Object form, except as required
  #     in copyright, patent, trademark, and attribution notices.
  license :cannot_represent
  head "https://github.com/wg/wrk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105d8b08ec6d0931a3f781f80590ce9d8f4cb6b916a16739acabd7b935c4df98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad9927f8d62c05e5b7b0e81a8d0cd055d3489957d64c8313f77e4f7520455154"
    sha256 cellar: :any_skip_relocation, monterey:       "4579ff219025872daf408da70f8ca45f496bc3f768b6baad68bd04a6e555ff10"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfdae1263316f4d65344b2c7890e3d4bfe14938146aad47eba5598e93f6ef0c4"
    sha256 cellar: :any_skip_relocation, catalina:       "e589229b31a5b4d71028c39dbacd91b392ccfc88e548868fd227b35495761230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971a44b8fc296eb7148763277306af8e022210f4ed518a0a290c82730bd1bfef"
  end

  depends_on "luajit"
  depends_on "openssl@3"

  conflicts_with "wrk-trello", because: "both install `wrk` binaries"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    ENV.append_to_cflags "-I#{Formula["luajit"].opt_include}/luajit-2.1"
    args = %W[
      WITH_LUAJIT=#{Formula["luajit"].opt_prefix}
      WITH_OPENSSL=#{Formula["openssl@3"].opt_prefix}
    ]
    args << "VER=#{version}" unless build.head?
    system "make", *args
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end
