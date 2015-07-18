class AddGroupToContest < ActiveRecord::Migration
  def up
    create_table :groups do |t|
      t.string :name
    end
    add_reference :contests, :group, index: true, foreign_key: true, null: false, default: 1

  #create groups
    
    general_group = Group.create(name: "Общи")
    control_group = Group.create(name: "Контроли за IOI")
    spring_group = Group.create(name: "Пролетен турнир")
    noi_group = Group.create(name: "НОИ")
    winter_group = Group.create(name: "Зимни състезания")
    autumn_group = Group.create(name: "Есенен турнир")
    rmms_group = Group.create(name: "RMMS")
    apio_group = Group.create(name: "APIO")
    usaco_group = Group.create(name: "USACO")
    boi_group = Group.create(name: "BOI and JBOI")
    daa_group = Group.create(name: "ДАА")
    arena_group = Group.create(name: "Арена")
      #match groups      
      Contest.find_each do |contest|
        if(contest.name.include? "контролно група")||(contest.name.include? "контролно групи")||(contest.name.include? "Контрол")||(contest.name.include? "контролно")
          contest.update!(group: control_group)
        elsif(contest.name.include? "Пролетен")
          contest.update!(group: spring_group)
        elsif(contest.name.include? "НОИ")
          contest.update!(group: noi_group)
        elsif(contest.name.include? "Зимни")||(contest.name.include? "ЗМП")
          contest.update!(group: winter_group)
        elsif(contest.name.include? "Есенен")
          contest.update!(group: autumn_group)
        elsif(contest.name.include? "RMMS")
          contest.update!(group: rmms_group)
        elsif(contest.name.include? "APIO")
          contest.update!(group: apio_group)
        elsif(contest.name.include? "USACO")
          contest.update!(group: usaco_group)
        elsif(contest.name.include? "BOI")
          contest.update!(group: boi_group)
        elsif(contest.name.include? "ДАА")
          contest.update!(group: daa_group)        
        elsif(contest.name.include? "Арена")||(contest.name.include? "Maycamp")
          contest.update!(group: arena_group)
        else
          contest.update!(group: general_group)
        end
      end
  end



  def down
    drop_table :groups
    remove_reference :contests, :group
  end
end

