require 'test_helper'

class SakesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sake = sakes(:one)
  end

  test "should get index" do
    get sakes_url
    assert_response :success
  end

  test "should get new" do
    get new_sake_url
    assert_response :success
  end

  test "should create sake" do
    assert_difference('Sake.count') do
      post sakes_url, params: { sake: { acidity: @sake.acidity, aged: @sake.aged, alcohol: @sake.alcohol, amino_acid: @sake.amino_acid, aroma_int: @sake.aroma_int, aroma_text: @sake.aroma_text, awa: @sake.awa, bindume: @sake.bindume, by: @sake.by, color: @sake.color, genryoumai: @sake.genryoumai, is_genshu: @sake.is_genshu, is_namacho: @sake.is_namacho, is_namadume: @sake.is_namadume, kakemai: @sake.kakemai, koubo: @sake.koubo, kura: @sake.kura, memo: @sake.memo, moto: @sake.moto, name: @sake.name, nigori: @sake.nigori, photo: @sake.photo, product_of: @sake.product_of, rice_polishing: @sake.rice_polishing, roka: @sake.roka, sake_metre_value: @sake.sake_metre_value, shibori: @sake.shibori, taste_int: @sake.taste_int, taste_text: @sake.taste_text, tokutei_meisho: @sake.tokutei_meisho, touroku: @sake.touroku } }
    end

    assert_redirected_to sake_url(Sake.last)
  end

  test "should show sake" do
    get sake_url(@sake)
    assert_response :success
  end

  test "should get edit" do
    get edit_sake_url(@sake)
    assert_response :success
  end

  test "should update sake" do
    patch sake_url(@sake), params: { sake: { acidity: @sake.acidity, aged: @sake.aged, alcohol: @sake.alcohol, amino_acid: @sake.amino_acid, aroma_int: @sake.aroma_int, aroma_text: @sake.aroma_text, awa: @sake.awa, bindume: @sake.bindume, by: @sake.by, color: @sake.color, genryoumai: @sake.genryoumai, is_genshu: @sake.is_genshu, is_namacho: @sake.is_namacho, is_namadume: @sake.is_namadume, kakemai: @sake.kakemai, koubo: @sake.koubo, kura: @sake.kura, memo: @sake.memo, moto: @sake.moto, name: @sake.name, nigori: @sake.nigori, photo: @sake.photo, product_of: @sake.product_of, rice_polishing: @sake.rice_polishing, roka: @sake.roka, sake_metre_value: @sake.sake_metre_value, shibori: @sake.shibori, taste_int: @sake.taste_int, taste_text: @sake.taste_text, tokutei_meisho: @sake.tokutei_meisho, touroku: @sake.touroku } }
    assert_redirected_to sake_url(@sake)
  end

  test "should destroy sake" do
    assert_difference('Sake.count', -1) do
      delete sake_url(@sake)
    end

    assert_redirected_to sakes_url
  end
end
