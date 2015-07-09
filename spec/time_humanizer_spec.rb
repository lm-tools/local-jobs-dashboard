require 'time_humanizer'

describe TimeHumanizer do

  let(:now) { DateTime.new(2015,1,1,12,0,0)}
  let(:seconds) { rand(0...59) }
  let(:time) { now - seconds/86400.0 }
  let(:result) { described_class.new(now, time).run }

  context "the time is strictly less than a minute ago" do
    it "returns 'now'" do
      expect(result).to eq "now"
    end
  end
  context "the time is more than a minute and strictly less than an hour ago" do
    let(:seconds) { rand(120...3599) }
    it "returns 'x minutes ago'" do
      expect(result).to eq "#{seconds/60} minutes ago"
    end
    context "one minute ago" do
      let(:seconds) { rand(60...119) }
      it "returns '1 minute ago'" do
        expect(result).to eq "1 minute ago"
      end
    end
  end
  context "the time is more than an hour and strictly less than a day ago" do
    let(:seconds) { rand(7200...86399) }
    it "returns 'x hours ago'" do
      expect(result).to eq "#{seconds/3600} hours ago"
    end
    context "one hour ago" do
      let(:seconds) { rand(3600...7199) }
      it "returns '1 hour ago'" do
        expect(result).to eq "1 hour ago"
      end
    end
  end
  context "the time is more than a day ago" do
    let(:seconds) { rand(172800...500000) }
    it "returns 'x days ago'" do
      expect(result).to eq "#{seconds/86400} days ago"
    end
    context "one day ago" do
      let(:seconds) { rand(86400...172799) }
      it "returns '1 day ago'" do
        expect(result).to eq "1 day ago"
      end
    end
  end

end
