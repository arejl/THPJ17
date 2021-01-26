require "pry"
require_relative "player"

$warrior_names = ["Ryu", "Necro", "Oro", "Sean Matsuda", "Yang Lee", "Yun Lee", "Alex", "Dudley", "Elena", "Gill", "Ibuki", "Ken Masters", "E. Honda", "Blanka", "Guile", "Ken", "Akuma", "M. Bison", "Chun-Li", "Zangieff", "Dhalsim"]

class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(given_name)
    @human_player = HumanPlayer.new(given_name)
    @enemies_in_sight = Array.new
    @players_left = 10
    while @enemies_in_sight.size < 1 do
      self.new_players_in_sight 
    end
  end

  def kill_player(player_name)
    @enemies_in_sight.delete_if { |enemy| enemy.name == player_name }
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && @enemies_in_sight.size > 0
  end

  def show_players
    @human_player.show_state
    if @enemies_in_sight.size == 1
      puts "Il reste #{@enemies_in_sight.size} joueur à combattre"
    else
      puts "Il reste #{@enemies_in_sight.size} joueurs à combattre"
    end
  end

  def new_players_in_sight
    if @enemies_in_sight.size == @players_left
      puts "Tous les joueurs sont déjà en vue"
    else
      case rand(1..6)
      when 1
        puts "Aucun adversaire supplémentaire n'arrive"
      when 2..4
        puts "Un nouvel adversaire arrive en vue !"
        player_extra = Player.new($warrior_names.sample)
        @enemies_in_sight << player_extra
      else
        puts "Deux nouveaux adversaires arrivent en vue !"
        player_extra = Player.new($warrior_names.sample)
        @enemies_in_sight << player_extra
        player_extra_2 = Player.new($warrior_names.sample)
        @enemies_in_sight << player_extra_2
      end
    end
  end

  def menu
    puts
    puts "Quelle action veux-tu effectuer ?"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner"
    puts
    puts "attaquer un joueur en vue :"
    @enemies_in_sight.each_with_index do |enemy, index|
      print "#{index} - "
      enemy.show_state
    end
  end

  def menu_choice
    print ">"
    choice = gets.chomp
    puts
    (0..@enemies_in_sight.size - 1).each do |i|
      if choice == "#{i}"
        @human_player.attacks(@enemies_in_sight[i])
        if @enemies_in_sight[i].life_points <= 0
          kill_player(@enemies_in_sight[i].name)
        end
      elsif choice == "a" || choice == "A"
        @human_player.search_weapon
        break
      elsif choice == "s" || choice == "S"
        @human_player.search_health_pack
        break
      else
        next
      end
    end
  end

  def enemies_attack
    puts
    if @enemies_in_sight.size > 0
      puts "Les autres joueurs attaquent !"
      @enemies_in_sight.each do |enemy|
        enemy.attacks(@human_player)
      end
    else
      puts "Il n'y a plus d'autre joueur en vie !"
    end
  end

  def end
    if @human_player.life_points > 0
      puts "Bravo ! Tu as gagné !"
    else
      puts "Tu as perdu..."
    end
  end
end
