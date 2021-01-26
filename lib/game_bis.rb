require "pry"
require_relative "player"

class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(given_name)
    @human_player = HumanPlayer.new(given_name)
    @enemies_in_sight = Array.new
    @players_left = 10
    while @enemies_in_sight.size < 1
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
    if @human_player.life_points > 0 && @enemies_in_sight.size >= @players_left
      puts "Tous les joueurs sont déjà en vue"
    elsif @human_player.life_points > 0
      case rand(1..6)
      when 1
        puts "Aucun adversaire supplémentaire n'arrive"
      when 2..4
        puts "Un nouvel adversaire arrive en vue !"
        player_extra = Player.new("Joueur #{rand(1..10000)}")
        @enemies_in_sight << player_extra
      else
        puts "Deux nouveaux adversaires arrivent en vue !"
        player_extra = Player.new("Joueur #{rand(1..10000)}")
        @enemies_in_sight << player_extra
        player_extra_2 = Player.new("Joueur #{rand(1..10000)}")
        @enemies_in_sight << player_extra_2
      end
      #Rien ne se passe si le joueur n'a plus de points de vie.
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
    loop do
      control = 0 #Cette variable va servir à proposer à nouveau le menu si l'utilisateur n'a pas rentré de valeur acceptable.
      print ">"
      choice = gets.chomp
      puts
      (0..@enemies_in_sight.size - 1).each do |i|
        if choice == "#{i}"
          @human_player.attacks(@enemies_in_sight[i])
          if @enemies_in_sight[i].life_points <= 0
            kill_player(@enemies_in_sight[i].name)
          end
          control += 1
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
    if @enemies_in_sight.size > 0
      puts "Les autres joueurs attaquent !"
      @enemies_in_sight.each do |enemy|
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
