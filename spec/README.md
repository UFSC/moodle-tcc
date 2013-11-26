Convenções de escrita de testes
===============================

Fabricators
-----------

Todo model que for testado precisa ter um ou mais fabricators associados a ele.

Para esse projeto como as relações são bastante acopladas, vamos gerar sempre
dois fabricators para cada model (no mesmo arquivo):

* <ModelName>_minimal : Este será o fabricator com todos os campos preenchidos exceto as relações
* <ModelName_with_all : Este será o fabricator com todas as relações do tipo has_many

Com essas duas relações é possível gerar models específicos para os testes que dependam de algum
ajuste específico nas relações ou simplesmente obter uma versão válida