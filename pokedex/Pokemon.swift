//
//  Pokemon.swift
//  pokedex
//
//  Created by ryan on 1/27/17.
//  Copyright © 2017 ryan. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    private var _movesTxt: String!
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var movesTxt: String {
        if _movesTxt == nil {
            _movesTxt = ""
        }
        return _movesTxt
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        let url = URL(string: _pokemonUrl)!
        print(_pokemonUrl)
        
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            
            print(result.value.debugDescription)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._baseAttack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    
                    if let uri = descArr[0]["resource_uri"] {
                        
                        let url = URL(string: "\(URL_BASE)\(uri)")!
                        print(url)
                        
                        Alamofire.request(url).responseJSON { response in
                            let descResult = response.result
                            
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                                
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        // can't support mega pokemon right now but api still has mega data
                        if to.range(of: "mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                
                                let num = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLvl)
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>], moves.count > 0 {
                    
                    //var counter = 1
                    
                    var learnTypesTutor = ""
                    var learnTypesMachine = ""
                    var learnTypesLevelUp = ""
                    var learnTypesOther = ""
                    
                    
//                    if let name = moves[0]["name"] as? String, let learn_type = moves[0]["learn_type"] as? String {
//                        self._movesTxt = "\(counter). " + name.capitalized + " (" + learn_type.capitalized + ")"
//                        counter += 1;
//                    }
                    
                    if moves.count > 0 {
                        for x in 0 ..< moves.count {
                            if let name = moves[x]["name"] as? String, let learn_type = moves[x]["learn_type"] as? String {
                                
                                var seperator = ""
                                
                                if x > 0 {
                                    seperator = ", "
                                }
                                
                                switch learn_type
                                {
                                    case "tutor":
                                        if learnTypesTutor == "" {
                                            seperator = "Tutor: "
                                        } else {
                                            seperator = ", "
                                        }
                                        learnTypesTutor += seperator + name.capitalized
                                    case "machine":
                                        if learnTypesMachine == "" {
                                            seperator = "Machine: "
                                        } else {
                                            seperator = ", "
                                        }
                                        learnTypesMachine += seperator + name.capitalized
                                    case "level up":
                                        if learnTypesLevelUp == "" {
                                            seperator = "Level Up: "
                                        } else {
                                            seperator = ", "
                                        }
                                        learnTypesLevelUp += seperator + name.capitalized
                                    default:
                                        if learnTypesOther == "" {
                                            seperator = "Other: "
                                        } else {
                                            seperator = ", "
                                        }
                                        learnTypesOther += seperator + name.capitalized
                                }
                            }
                        }
                        
                        self._movesTxt = learnTypesTutor + "\n\n" + learnTypesMachine + "\n\n" + learnTypesLevelUp + "\n\n" + learnTypesOther
                    }
                    
                } else {
                    self._movesTxt = ""
                }
                
                print(self._movesTxt)
                
            }
            
        }
        
    }
    
}
