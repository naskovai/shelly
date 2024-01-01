class Shelly < Formula
  desc "Shelly translates English instructions to terminal commands."
  homepage "https://github.com/paletov/shelly"
  url "https://github.com/paletov/shelly/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "4389e7bf5ce2c36c8c879069f000d6d66d5bbe8c918ec8e0300e537a3fc710c8"
  version File.read(File.expand_path("../version.txt", __dir__)).strip

  depends_on "python@3"
  depends_on "sqlite"

  def install
    # Install Python dependencies from requirements.txt into libexec
    system "pip3", "install", "-r", "requirements.txt", "--target=#{libexec}", "--upgrade"

    # Install all files into a subdirectory of libexec
    libexec.install Dir["*"]

    # Create a symlink in the bin directory to the shelly.sh script
    (bin/"shelly").write_env_script(libexec/"shelly.sh", PYTHONPATH: libexec)
  end

  def caveats
    <<~EOS
      Note: Uninstalling Shelly does not automatically remove the '~/.shelly' directory,
      which may contain configuration files and user data. If you wish to completely remove all
      traces of Shelly, please delete this directory manually.
    EOS
  end

  test do
    # Replace this with a command that proves the tool was installed correctly
    system "#{bin}/shelly", "--version"
  end
end
