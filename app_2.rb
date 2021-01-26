require "bundler"
Bundler.require

require_relative "lib/game"
require_relative "lib/player"

$enemies = Array.new
$enemies << $enemy1 = Player.new("Josiane")
$enemies << $enemy2 = Player.new("José")

def intro
  puts "------------------------------------------------"
  puts "|Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |"
  puts "|Le but du jeu est d'être le dernier survivant !|"
  puts "-------------------------------------------------"
  puts "C'est moi, le prof. CHEN ! Comment t'appelles-tu déjà ?"
  print ">"
  given_name = gets.chomp
  return $user = HumanPlayer.new(given_name)
end

def menu
  puts
  puts "Voici ton état :"
  $user.show_state
  puts
  puts "Quelle action veux-tu effectuer ?"
  puts "a - chercher une meilleure arme"
  puts "s - chercher à se soigner"
  puts
  puts "attaquer un joueur en vue :"
  $enemies.each_with_index do |enemy, index|
    print "#{index} - "
    enemy.show_state
  end
  print ">"
  return $answer = gets.chomp
end

def user_decision
  puts
  loop do
    menu
    case $answer
    when "a" || "A"
      $user.search_weapon
      break
    when "s" || "S"
      $user.search_health_pack
      break
    when "0"
      $user.attacks($enemies[0])
      break
    when "1"
      $user.attacks($enemies[1])
      break
    else
      puts "Entre une réponse valide stp"
    end
  end
end

def enemy_attack
  puts
  if ($enemy1.life_points > 0 || $enemy2.life_points > 0)
    puts "Les autres joueurs attaquent !"
    $enemies.each do |enemy|
      if enemy.life_points > 0
        enemy.attacks($user)
      end
    end
  else
    puts "Il n'y a plus d'autre joueur en vie !"
  end
end

def end_game
  if $user.life_points > 0
    puts "Bravo ! Tu as gagné !"
  else
    puts "Tu as perdu..."
  end
end

def game
  intro
  while $user.life_points > 0 && ($enemy1.life_points > 0 || $enemy2.life_points > 0)
    user_decision
    puts "------------------------------------------------"
    sleep(1)
    enemy_attack
    puts "------------------------------------------------"
    sleep(1)
  end
  end_game
end

game
