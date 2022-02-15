require "rails_helper"

RSpec.describe SakesHelper do
  include described_class

  describe "empty_to_default" do
    context "if first argument is presence" do
      value = 1
      default_value = 2

      it "returns first value" do
        expect(empty_to_default(value, default_value)).to eq(value)
      end
    end

    context "if first argument is nil" do
      nil_value = nil
      default_value = 2

      it "returns second value" do
        expect(empty_to_default(nil_value, default_value)).to eq(default_value)
      end
    end

    context "if first argument is empty string" do
      empty_string = ""
      default_value = 2

      it "returns second value" do
        expect(empty_to_default(empty_string, default_value)).to eq(default_value)
      end
    end
  end

  describe "year_range" do
    it "generates a range ending with 2021" do
      expect(year_range(2021).last).to eq(2021)
    end

    it "generates a range starting with 1991, (2021 - 30)" do
      expect(year_range(2021).first).to eq(1991)
    end

    it "generates a range ending with 2030" do
      expect(year_range(2030).last).to eq(2030)
    end

    it "generates a range starting with 2000, (2030 - 30)" do
      expect(year_range(2030).first).to eq(2000)
    end
  end

  describe "to_by" do
    let(:date) { Date.current }

    it "always returns July" do
      expect(to_by(date).month).to eq(7)
    end

    it "always returns day 1" do
      expect(to_by(date).day).to eq(1)
    end

    context "if date is after 7/1" do
      let(:date) { Date.new(2021, 7, 1) }

      it "returns same year" do
        expect(to_by(date).year).to eq(date.year)
      end
    end

    context "if date is before 6/30" do
      let(:date) { Date.new(2021, 6, 30) }

      it "returns yeara ago" do
        expect(to_by(date).year).to eq(date.year - 1)
      end
    end
  end

  describe "select_year_with_japanese_era" do
    # rubocop:disable Layout/LineLength
    it "returns select tag" do
      expect(select_year_with_japanese_era(latest_year: 2022)).to eq("<select><option value=\"1992\">1992 / 平成4年</option>\n<option value=\"1993\">1993 / 平成5年</option>\n<option value=\"1994\">1994 / 平成6年</option>\n<option value=\"1995\">1995 / 平成7年</option>\n<option value=\"1996\">1996 / 平成8年</option>\n<option value=\"1997\">1997 / 平成9年</option>\n<option value=\"1998\">1998 / 平成10年</option>\n<option value=\"1999\">1999 / 平成11年</option>\n<option value=\"2000\">2000 / 平成12年</option>\n<option value=\"2001\">2001 / 平成13年</option>\n<option value=\"2002\">2002 / 平成14年</option>\n<option value=\"2003\">2003 / 平成15年</option>\n<option value=\"2004\">2004 / 平成16年</option>\n<option value=\"2005\">2005 / 平成17年</option>\n<option value=\"2006\">2006 / 平成18年</option>\n<option value=\"2007\">2007 / 平成19年</option>\n<option value=\"2008\">2008 / 平成20年</option>\n<option value=\"2009\">2009 / 平成21年</option>\n<option value=\"2010\">2010 / 平成22年</option>\n<option value=\"2011\">2011 / 平成23年</option>\n<option value=\"2012\">2012 / 平成24年</option>\n<option value=\"2013\">2013 / 平成25年</option>\n<option value=\"2014\">2014 / 平成26年</option>\n<option value=\"2015\">2015 / 平成27年</option>\n<option value=\"2016\">2016 / 平成28年</option>\n<option value=\"2017\">2017 / 平成29年</option>\n<option value=\"2018\">2018 / 平成30年</option>\n<option value=\"2019\">2019 / 平成31年</option>\n<option value=\"2020\">2020 / 令和2年</option>\n<option value=\"2021\">2021 / 令和3年</option>\n<option selected=\"selected\" value=\"2022\">2022 / 令和4年</option></select>")
    end

    it "returns select tag with nil selection" do
      expect(select_year_with_japanese_era(latest_year: 2022, selected: nil, include_nil: "不明")).to eq("<select><option value=\"1992\">1992 / 平成4年</option>\n<option value=\"1993\">1993 / 平成5年</option>\n<option value=\"1994\">1994 / 平成6年</option>\n<option value=\"1995\">1995 / 平成7年</option>\n<option value=\"1996\">1996 / 平成8年</option>\n<option value=\"1997\">1997 / 平成9年</option>\n<option value=\"1998\">1998 / 平成10年</option>\n<option value=\"1999\">1999 / 平成11年</option>\n<option value=\"2000\">2000 / 平成12年</option>\n<option value=\"2001\">2001 / 平成13年</option>\n<option value=\"2002\">2002 / 平成14年</option>\n<option value=\"2003\">2003 / 平成15年</option>\n<option value=\"2004\">2004 / 平成16年</option>\n<option value=\"2005\">2005 / 平成17年</option>\n<option value=\"2006\">2006 / 平成18年</option>\n<option value=\"2007\">2007 / 平成19年</option>\n<option value=\"2008\">2008 / 平成20年</option>\n<option value=\"2009\">2009 / 平成21年</option>\n<option value=\"2010\">2010 / 平成22年</option>\n<option value=\"2011\">2011 / 平成23年</option>\n<option value=\"2012\">2012 / 平成24年</option>\n<option value=\"2013\">2013 / 平成25年</option>\n<option value=\"2014\">2014 / 平成26年</option>\n<option value=\"2015\">2015 / 平成27年</option>\n<option value=\"2016\">2016 / 平成28年</option>\n<option value=\"2017\">2017 / 平成29年</option>\n<option value=\"2018\">2018 / 平成30年</option>\n<option value=\"2019\">2019 / 平成31年</option>\n<option value=\"2020\">2020 / 令和2年</option>\n<option value=\"2021\">2021 / 令和3年</option>\n<option value=\"2022\">2022 / 令和4年</option>\n<option selected=\"selected\" value=\"\">不明</option></select>")
    end
    # rubocop:enable Layout/LineLength
  end

  describe "bottom_bottle" do
    it "must always return -1" do
      expect(bottom_bottle).to eq(-1)
    end
  end

  describe "to_shakkan" do
    it "returns value by Shakkan" do
      expect(to_shakkan(4500)).to eq("2升5合")
    end

    it "truncates and returns value" do
      expect(to_shakkan(300)).to eq("1合")
    end

    it "returns value without new unit over 10 Koku" do
      expect(to_shakkan(2_222_100)).to eq("12石3斗4升5合")
    end

    it "returns without the not beggiest zero" do
      expect(to_shakkan(18000)).to eq("1斗")
    end

    it "returns zero with Go" do
      expect(to_shakkan(0)).to eq("0合")
    end

    it "returns zero Go with argument less than 180" do
      expect(to_shakkan(100)).to eq("0合")
    end
  end
end
