require "pry"
require_relative "player"

class Game
  attr_accessor :human_player, :enemies

  def initialize(given_name)
    @human_player = HumanPlayer.new(given_name)
    @enemies = Array.new
    4.times do |i|
      @enemies << Player.new("Joueur #{i + 1}")
    end
  end

  def kill_player
    @enemies.delete_if { |enemy| enemy.life_points <= 0 }
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && @enemies.size > 0
  end

  def show_players
    @human_player.show_state
    if @enemies.size == 1
      puts "Il reste #{@enemies.size} joueur à combattre"
    else
      puts "Il reste #{@enemies.size} joueurs à combattre"
    end
  end

  def menu
    puts
    puts "Quelle action veux-tu effectuer ?"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner"
    puts
    puts "attaquer un joueur en vue :"
    @enemies.each_with_index do |enemy, index|
      print "#{index} - "
      enemy.show_state
    end
  end

  def menu_choice
    loop do
      control = 0 #Cette variable va servir à proposer à nouveau le menu si l'utilisateur n'a pas rentré de valeur acceptable.
      print ">"
      choice = gets.chomp
      puts
      (0..@enemies.size - 1).each do |i|
        if choice == "#{i}"
          @human_player.attacks(@enemies[i])
          control += 1
          if @enemies[i].life_points <= 0
            self.kill_player
          end
        elsif choice == "a" || choice == "A"
          @human_player.search_weapon
          control += 1
          break #On rajoute des break pour sortir du each si le choix de l'utilisateur est a ou s
        elsif choice == "s" || choice == "S"
          @human_player.search_health_pack
          control += 1
          break
        else
          next
        end
      end
      if control == 0
        puts "Entre un choix valide stp" #Retour au début de la loop si l'utilisateur a donné une valeur qui n'est pas dans le menu
      else
        break
      end
    end
  end

  def enemies_attack
    puts
    if @enemies.size > 0
      puts "Les autres joueurs attaquent !"
      @enemies.each do |enemy|
        if @human_player.life_points > 0
          enemy.attacks(@human_player)
        else
          break #Si le joueur n'a plus de vie, le reste des ennemis n'attaque pas.
        end
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
