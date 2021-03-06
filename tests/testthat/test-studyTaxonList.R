context("Verifies performance of studyTaxonList")

library(occCite)

test_that("phylogeny can be read and manipulated as expected", {
  phylogeny <- ape::read.nexus(system.file("extdata/Fish_12Tax_time_calibrated.tre",
    package = "occCite"
  ))
  phylogeny <- ape::extract.clade(phylogeny, 18)

  expect_true(class(phylogeny) == "phylo")
  expect_true(length(phylogeny$tip.label) == 7)
})

test_that("studyTaxonList works with a phylogeny", {
  phylogeny <- ape::read.nexus(system.file("extdata/Fish_12Tax_time_calibrated.tre",
    package = "occCite"
  ))
  phylogeny <- ape::extract.clade(phylogeny, 18)
  testResult <- studyTaxonList(x = phylogeny, datasources = c("National Center for Biotechnology Information"))

  expect_true(class(testResult) == "occCiteData")
  expect_true("userQueryType" %in% slotNames(testResult))
  expect_true("userSpecTaxonomy" %in% slotNames(testResult))
  expect_true("cleanedTaxonomy" %in% slotNames(testResult))
  expect_true("occSources" %in% slotNames(testResult))
  expect_true("occCiteSearchDate" %in% slotNames(testResult))
  expect_true("occResults" %in% slotNames(testResult))

  expect_true(testResult@userQueryType == "User-supplied phylogeny.")
  expect_true(testResult@userSpecTaxonomy == "National Center for Biotechnology Information")

  expect_true(class(testResult@cleanedTaxonomy) == "data.frame")
  expect_true(nrow(testResult@cleanedTaxonomy) == 7)
  expect_true("Input Name" %in% colnames(testResult@cleanedTaxonomy))
  expect_true("Best Match" %in% colnames(testResult@cleanedTaxonomy))
  expect_true("Taxonomic Databases w/ Matches"
  %in% colnames(testResult@cleanedTaxonomy))

  expect_true(length(testResult@occSources) == 0)
  expect_true(length(testResult@occCiteSearchDate) == 0)
  expect_true(length(testResult@occResults) == 0)
})

test_that("studyTaxonList works with a vector of species", {
  taxVector <- c("Buteo buteo", "Buteo buteo hartedi", "Buteo japonicus")
  testResult <- studyTaxonList(x = taxVector, datasources = c("National Center for Biotechnology Information"))

  expect_true(class(testResult) == "occCiteData")
  expect_true("userQueryType" %in% slotNames(testResult))
  expect_true("userSpecTaxonomy" %in% slotNames(testResult))
  expect_true("cleanedTaxonomy" %in% slotNames(testResult))
  expect_true("occSources" %in% slotNames(testResult))
  expect_true("occCiteSearchDate" %in% slotNames(testResult))
  expect_true("occResults" %in% slotNames(testResult))

  expect_true(testResult@userQueryType == "User-supplied list of taxa.")
  expect_true(testResult@userSpecTaxonomy == "National Center for Biotechnology Information")

  expect_true(class(testResult@cleanedTaxonomy) == "data.frame")
  expect_true(nrow(testResult@cleanedTaxonomy) == 3)
  expect_true("Input Name" %in% colnames(testResult@cleanedTaxonomy))
  expect_true("Best Match" %in% colnames(testResult@cleanedTaxonomy))
  expect_true("Taxonomic Databases w/ Matches"
  %in% colnames(testResult@cleanedTaxonomy))

  expect_true(length(testResult@occSources) == 0)
  expect_true(length(testResult@occCiteSearchDate) == 0)
  expect_true(length(testResult@occResults) == 0)
})
