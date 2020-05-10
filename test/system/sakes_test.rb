require "application_system_test_case"

class SakesTest < ApplicationSystemTestCase
  setup do
    @sake = sakes(:one)
  end

  test "visiting the index" do
    visit sakes_url
    assert_selector "h1", text: "Sakes"
  end

  test "creating a Sake" do
    visit sakes_url
    click_on "New Sake"

    fill_in "Acidity", with: @sake.acidity
    fill_in "Aged", with: @sake.aged
    fill_in "Alcohol", with: @sake.alcohol
    fill_in "Amino acid", with: @sake.amino_acid
    fill_in "Aroma int", with: @sake.aroma_int
    fill_in "Aroma text", with: @sake.aroma_text
    fill_in "Awa", with: @sake.awa
    fill_in "Bindume", with: @sake.bindume
    fill_in "By", with: @sake.by
    fill_in "Color", with: @sake.color
    fill_in "Genryoumai", with: @sake.genryoumai
    check "Is genshu" if @sake.is_genshu
    check "Is namacho" if @sake.is_namacho
    check "Is namadume" if @sake.is_namadume
    fill_in "Kakemai", with: @sake.kakemai
    fill_in "Koubo", with: @sake.koubo
    fill_in "Kura", with: @sake.kura
    fill_in "Memo", with: @sake.memo
    fill_in "Moto", with: @sake.moto
    fill_in "Name", with: @sake.name
    fill_in "Nigori", with: @sake.nigori
    fill_in "Photo", with: @sake.photo
    fill_in "Product of", with: @sake.product_of
    fill_in "Rice polishing", with: @sake.rice_polishing
    fill_in "Roka", with: @sake.roka
    fill_in "Sake metre value", with: @sake.sake_metre_value
    fill_in "Shibori", with: @sake.shibori
    fill_in "Taste int", with: @sake.taste_int
    fill_in "Taste text", with: @sake.taste_text
    fill_in "Tokutei meisho", with: @sake.tokutei_meisho
    fill_in "Touroku", with: @sake.touroku
    click_on "Create Sake"

    assert_text "Sake was successfully created"
    click_on "Back"
  end

  test "updating a Sake" do
    visit sakes_url
    click_on "Edit", match: :first

    fill_in "Acidity", with: @sake.acidity
    fill_in "Aged", with: @sake.aged
    fill_in "Alcohol", with: @sake.alcohol
    fill_in "Amino acid", with: @sake.amino_acid
    fill_in "Aroma int", with: @sake.aroma_int
    fill_in "Aroma text", with: @sake.aroma_text
    fill_in "Awa", with: @sake.awa
    fill_in "Bindume", with: @sake.bindume
    fill_in "By", with: @sake.by
    fill_in "Color", with: @sake.color
    fill_in "Genryoumai", with: @sake.genryoumai
    check "Is genshu" if @sake.is_genshu
    check "Is namacho" if @sake.is_namacho
    check "Is namadume" if @sake.is_namadume
    fill_in "Kakemai", with: @sake.kakemai
    fill_in "Koubo", with: @sake.koubo
    fill_in "Kura", with: @sake.kura
    fill_in "Memo", with: @sake.memo
    fill_in "Moto", with: @sake.moto
    fill_in "Name", with: @sake.name
    fill_in "Nigori", with: @sake.nigori
    fill_in "Photo", with: @sake.photo
    fill_in "Product of", with: @sake.product_of
    fill_in "Rice polishing", with: @sake.rice_polishing
    fill_in "Roka", with: @sake.roka
    fill_in "Sake metre value", with: @sake.sake_metre_value
    fill_in "Shibori", with: @sake.shibori
    fill_in "Taste int", with: @sake.taste_int
    fill_in "Taste text", with: @sake.taste_text
    fill_in "Tokutei meisho", with: @sake.tokutei_meisho
    fill_in "Touroku", with: @sake.touroku
    click_on "Update Sake"

    assert_text "Sake was successfully updated"
    click_on "Back"
  end

  test "destroying a Sake" do
    visit sakes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sake was successfully destroyed"
  end
end
