class Pvcount < ActiveRecord::Base
  paginates_per 5
  belongs_to :question

  def self.set_counter(target_qid, target_timescope)
    pvcount = Pvcount.find_by(question_id: target_qid, timescope: target_timescope)
    
    #該当するカウンタが存在しなければ新規登録
    unless pvcount
      pvcount = Pvcount.new(question_id: target_qid, timescope: target_timescope)

      t_timescope = []
      i_timescope = []
      cnt = []
      str_timescope = target_timescope.to_s
      time_y = str_timescope[0..3].to_i
      time_m = str_timescope[4..5].to_i
      time_d = str_timescope[6..7].to_i
      time_h = str_timescope[8..9].to_i
      t_timescope[0] = Time.local(time_y, time_m, time_d, time_h, 0, 0)
      
      #23時間前の時間帯のカウンタから値を取得
      t_timescope[23] = t_timescope[0] - (23 * 3600)
      i_timescope[23] = t_timescope[23].strftime("%Y%m%d%H").to_i
      cnt[23] = Pvcount.find_by(question_id: target_qid, timescope: i_timescope[23])
      unless cnt[23]
        pvcount.pv_prev23 = 0
      else
        pvcount.pv_prev23 = cnt[23].pv
      end
      
      #1つ前の時間帯のカウンタから値を取得
      t_timescope[1] = t_timescope[0] - (1 * 3600)
      i_timescope[1] = t_timescope[1].strftime("%Y%m%d%H").to_i
      cnt[1] = Pvcount.find_by(question_id: target_qid, timescope: i_timescope[1])
      unless cnt[1]
        for i in 2..22 do
          t_timescope[i] = t_timescope[0] - (i * 3600)
          i_timescope[i] = t_timescope[i].strftime("%Y%m%d%H").to_i
          cnt[i] = Pvcount.find_by(question_id: target_qid, timescope: i_timescope[i])
          unless cnt[i]
            pvcount.pv_24hr = pvcount.pv_24hr + 0
          else
            pvcount.pv_24hr = pvcount.pv_24hr + cnt[i].pv
          end
        end
      else
        pvcount.pv_24hr = cnt[1].pv_24hr - cnt[1].pv_prev23
      end
      
      pvcount.save
    end
    
    # 処理が終わる前に戻り値として明示的にセット
    pvcount
  end
  
  def self.update_timescope
    last_cnt = Pvcount.order(updated_at: :desc).limit(1)
    present_time = Time.now
    i_timescope = []
    prev_time = []
    i_timescope[0] = present_time.strftime("%Y%m%d%H").to_i
    tmp = i_timescope[0] - last_cnt[0].timescope
    unless tmp == 0
      for i in 1..23 do
        prev_time[i] = present_time - (i * 3600)
        i_timescope[i] = prev_time[i].strftime("%Y%m%d%H").to_i
        pvcounts = Pvcount.where(timescope: i_timescope[i])
        pvcounts.each do |cnt|
          Pvcount.set_counter(cnt.question.id, i_timescope[0])
        end
      end
    end
  end
  
end
