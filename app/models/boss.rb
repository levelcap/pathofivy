class Boss < ApplicationRecord

    @@failures = [
        "Suddenly, a bolt of lightning streaks through the body of BOSSNAME, "\
        "causing them to explode in a shower of shiny lights! As spectacular as it was, nobody "\
        "really learned anything from the experience.",
        "Suddenly, a CUTENESS EXPLOSION rocks the battlefield as everybody is showered in "\
        "cute snuggly puppies! Everyone sensibly decides to abandon the battle with BOSSNAME and "\
        "have puppy playtime instead. Nobody learned anything, but everyone got to snuggle with puppies so it's okay."
      ]

      def self.getRandomRaidWipe(boss)
        return @@failures.sample.sub("BOSSNAME", boss.name)
      end

end
