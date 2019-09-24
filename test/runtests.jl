using SMILES
using Test

@testset "Read Next Element" begin
    @test SMILES.ReadNextElement( "ScC", SMILES.bracket ) == ("Sc", "C")
    @test SMILES.ReadNextElement( "ScAs", SMILES.bracket ) == ("Sc", "As")
    @test SMILES.ReadNextElement( "Sc", SMILES.bracket ) == ("Sc", "")
    @test SMILES.ReadNextElement( "CO", SMILES.bracket ) == ("C", "O")
    @test SMILES.ReadNextElement( "C", SMILES.bracket ) == ("C", "")
    @test SMILES.ReadNextElement( "s", SMILES.aromatics ) == ("s", "")
end

@testset "Read Next Numeric" begin
    @test SMILES.ReadNextNumeric("123UrC") == (123, "UrC")
    @test SMILES.ReadNextNumeric("UrC") == (nothing, "UrC")
    @test SMILES.ReadNextNumeric("12CH4") == (12, "CH4")
end

@testset "Read Next Charge" begin
    @test SMILES.ReadNextCharge("+") == (1, "")
    @test SMILES.ReadNextCharge("-") == (-1, "")
    @test SMILES.ReadNextCharge("+++") == (3, "")
    @test SMILES.ReadNextCharge("---") == (-3, "")
    @test SMILES.ReadNextCharge("+2") == (2, "")
    @test SMILES.ReadNextCharge("-2") == (-2, "")
end

@testset "Brackets Known" begin
    @test SMILES.ParseBracket("22NaH") == SMILES.Element("Na", 22, false, Int16[], 1, 0, 0)
    @test SMILES.ParseBracket("O-") == SMILES.Element("O", nothing, false, Int16[], 0, 0, -1)
    @test SMILES.ParseBracket("CH4") == SMILES.Element("C", nothing, false, Int16[], 4, 0, 0)
    @test SMILES.ParseBracket("CH3-") == SMILES.Element("C", nothing, false, Int16[], 3, 0, -1)
end

@testset "Brackets Equivalences" begin
    @test SMILES.ParseBracket("CH2--") == SMILES.ParseBracket("CH2-2")
    @test SMILES.ParseBracket("CH1---") == SMILES.ParseBracket("CH1-3")
    @test SMILES.ParseBracket("Fe++") == SMILES.ParseBracket("Fe+2")
    @test SMILES.ParseBracket("Fe+++") == SMILES.ParseBracket("Fe+3")
end

@testset "Parse SMILES Implicit Hydrogens" begin
    _, Data = SMILES.ParseSMILES("CCCC(C)C")
    checkhydrogens = Dict( SMILES.countitems( SMILES.H.( Data ) ) )
    @test checkhydrogens[1] == 1
    @test checkhydrogens[2] == 2
    @test checkhydrogens[3] == 3

    #Check a Ring
    _, Data = SMILES.ParseSMILES("C1CCC(C)C1")
    checkhydrogens = Dict( SMILES.countitems( SMILES.H.( Data ) ) )
    @test checkhydrogens[1] == 1
    @test checkhydrogens[2] == 4
    @test checkhydrogens[3] == 1
end
