require 'test_helper'

class HotelPlanTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test ".fetch_hotel_plan" do
    VCR.use_cassette('fetch_hotel_plan') do
      assert_difference ->{ HotelPlan.count } => 8, ->{ ActionMailer::Base.deliveries.size } => 1 do
        HotelPlan.fetch_hotel_plan
      end
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['jnchito@example.com'], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_equal '新しいプランが見つかりました', mail.subject

    plan_name = '【小学生を含む4名様限定♪】ベッドが1名分少ないけどお得！お日にち限定♪朝食付 | 【小学生を含む4名様限定】スタンダード※ベッド3台 (25㎡)禁煙'
    assert_includes mail.body, plan_name
    assert_includes mail.body, "74700円"

    plan_name = '【小学生を含む4名様限定♪】ベッドが1名分少ないけどお得！Baby’s ＆Kiddy Sweet★お日にち限定♪素泊り | 【小学生を含む4名様限定】【Kiddy Sweet】エクレール (25㎡)'
    assert_includes mail.body, plan_name
    assert_includes mail.body, "65100円"

    # すでに取込み済みであればメールを送信しない
    VCR.use_cassette('fetch_hotel_plan') do
      assert_no_difference [->{ HotelPlan.count }, ->{ ActionMailer::Base.deliveries.size }] do
        HotelPlan.fetch_hotel_plan
      end
    end

    # 1件だけ削除する
    plan_name = '【小学生を含む4名様限定♪】ベッドが1名分少ないけどお得！お日にち限定♪朝食付'
    room_name = '【小学生を含む4名様限定】スタンダード※ベッド3台 (25㎡)禁煙'
    HotelPlan.find_by!(plan_name: plan_name, room_name: room_name).destroy

    # 新規プランが1件でも見つかれば、メールを送信する
    VCR.use_cassette('fetch_hotel_plan') do
      assert_difference ->{ HotelPlan.count } => 1, ->{ ActionMailer::Base.deliveries.size } => 1 do
        HotelPlan.fetch_hotel_plan
      end
    end

    mail = ActionMailer::Base.deliveries.last
    plan_name = '【小学生を含む4名様限定♪】ベッドが1名分少ないけどお得！お日にち限定♪朝食付 | 【小学生を含む4名様限定】スタンダード※ベッド3台 (25㎡)禁煙'
    assert_includes mail.body, plan_name
    assert_includes mail.body, "74700円"
  end
end
