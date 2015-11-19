class CreateContestGroups < ActiveRecord::Migration
    def change
        create_table :contest_groups do |t|
            t.string :name

            t.timestamps null: false
        end

        contests=[
            'Общи',
            'Контроли за IOI',
            'Пролетен турнир',
            'НОИ',
            'Зимни състезания',
            'Есенен турнир',
            'RMMS',
            'APIO',
            'USACO',
            'BOI',
            'JBOI',
            'ДАА',
            'Арена'
        ]

        for content in contests
            ContestGroup.create!(name: content)
        end
    end

    def down
    end
end
