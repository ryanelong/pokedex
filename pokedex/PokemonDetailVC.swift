//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by ryan on 1/28/17.
//  Copyright © 2017 ryan. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bioStackView: UIStackView!
    @IBOutlet weak var movesLbl: UILabel!
    @IBOutlet weak var movesStackView: UIStackView!
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            // this will be called when the downloading is done
            self.updateUI()
        }
    }

    func updateUI() {
        
        descLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.baseAttack
        pokedexLbl.text = "\(pokemon.pokedexId)"
        movesLbl.text = pokemon.movesTxt
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
        
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segControlPressed(_ sender: UISegmentedControl) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // Bio Selected
            print(segmentedControl.titleForSegment(at: 0) ?? "")
            
            bioStackView.isHidden = false
            movesStackView.isHidden = true
            
        } else {
            //Moves Selected
            print(segmentedControl.titleForSegment(at: 1) ?? "")
            
            bioStackView.isHidden = true
            movesStackView.isHidden = false
            
            
        }
        
    }
}
