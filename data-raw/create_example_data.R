# Script to create example dataset for LandscapeLTR package

library(readr)

# Create a small example dataset
ltr_example <- data.frame(
  TE = c(
    "Chr01:66000000-66050000",
    "Chr01:66100000-66150000",
    "Chr01:66200000-66250000",
    "Chr01:66300000-66350000",
    "Chr01:66400000-66450000",
    "Chr01:66500000-66550000",
    "Chr01:66600000-66650000",
    "Chr01:66700000-66750000",
    "Chr01:66800000-66850000",
    "Chr01:66900000-66950000",
    "Chr01:67000000-67050000",
    "Chr01:67100000-67150000",
    "Chr01:67200000-67250000",
    "Chr01:67300000-67350000",
    "Chr01:67400000-67450000"
  ),
  Order = rep("LTR", 15),
  Superfamily = c(rep("Copia", 8), rep("Gypsy", 7)),
  Clade = c("Ale", "Bianca", "Tork", "Ale", "Bianca", "Ivana", "Tork", "Ale",
            "Athila", "CRM", "Tekay", "Athila", "CRM", "Tekay", "Retand"),
  Complete = c(rep("yes", 12), rep("no", 3)),
  Strand = c("+", "-", "+", "-", "+", "-", "+", "-", "+", "-", "+", "-", "+", "-", "+"),
  Domains = rep("GAG|PROT|INT|RT|RH", 15),
  stringsAsFactors = FALSE
)

# Save as R data
save(ltr_example, file = "../data/ltr_example.rda", compress = "xz")
