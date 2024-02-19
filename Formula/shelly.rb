class Shelly < Formula
  desc "Shelly translates English instructions to terminal commands."
  homepage "https://github.com/paletov/shelly"
  url "https://github.com/paletov/shelly/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a09749bc48194f3c2ad169f2da613cb7b84d526717a20957ff5515f1fe334378"
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
