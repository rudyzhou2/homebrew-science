class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "http://mallet.cs.umass.edu/"
  # tag "machine learning"

  url "http://mallet.cs.umass.edu/dist/mallet-2.0.7.tar.gz"
  sha256 "bf34241b0589be2d28d57a4b369b4d722f273591cb28bf428d0167f58f91f161"
  head "https://github.com/mimno/Mallet.git"

  devel do
    url "http://mallet.cs.umass.edu/dist/mallet-2.0.8RC2.tar.gz"
    sha256 "61f327f3237d814addfae484be146476d84bcbf829d9a669a4e08c4f21a6187c"
  end

  # Creates a wrapper to set the classpath before executing
  # the utility.
  def startup_script(name)
    <<-EOS.undent
      #!/bin/sh
      CLASSPATH=$CLASSPATH:#{libexec}/class:#{libexec}/lib/mallet-deps.jar "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files
    prefix.install_metafiles
    libexec.install Dir["*"]
    cd libexec+"bin" do
      Dir["*"].each do |file|
        fn = File.basename(file)
        (bin+fn).write startup_script(fn)
      end
    end
  end

  test do
    system "#{bin}/mallet | grep Mallet"
  end
end
