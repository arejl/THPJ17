require "pry"

class Player
  attr_accessor :name, :life_points

  def initialize(given_name)
    @name = given_name
    @life_points = 10
  end

  def show_state
    if @life_points <= 1
      puts "#{@name} a #{@life_points} point de vie"
    else
      puts "#{@name} a #{@life_points} points de vie"
    end
  end

  def gets_damage(damage)
    @life_points -= damage
    if @life_points <= 0
      puts "Le joueur #{@name} a été tué !"
    end
  end

  def compute_damage
    return rand(1..6)
  end

  def attacks(other_player)
    puts "Le joueur #{@name} attaque le joueur #{other_player.name}"
    damage = compute_damage
    if damage == 1
      puts "Il lui inflige #{damage} point de dommages !"
    else
      puts "Il lui inflige #{damage} points de dommages !"
    end
    other_player.gets_damage(damage)
  end
end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(given_name)
    super(given_name)
    @life_points = 100
    @weapon_level = 1
  end

  def show_state
    if @life_points <= 1
      puts "#{@name} a #{@life_points} point de vie et une arme de niveau #{@weapon_level}"
    else
      puts "#{@name} a #{@life_points} points de vie et une arme de niveau #{@weapon_level}"
    end
  end

  def compute_damage
    rand(1..6) * @weapon_level
  end

  def search_weapon
    weapon_found = rand(1..6)
    puts "#{@name} a trouvé une arme de niveau #{weapon_found}."
    if weapon_found > @weapon_level
      @weapon_level = weapon_found
      puts "Youhou ! Elle est meilleure que son arme actuelle : #{@name} la prend."
    else
      puts "M@*#$... elle n'est pas mieux que son arme actuelle..."
    end
  end

  def search_health_pack
    extra_health = rand(1..6)
    case extra_health
    when 1
      puts "#{@name} n'a rien trouvé..."
    when 2..5
      puts "#{@name} a trouvé un pack de +50 points de vie !"
      if @life_points <= 50
        @life_points += 50
      else
        @life_points = 100
      end
    else
      puts "Wow !!! #{@name} a trouvé un pack de +80 points de vie !"
      if @life_points <= 20
        @life_points += 80
      else
        @life_points = 100
      end
    end
    self.show_state
  end
end
