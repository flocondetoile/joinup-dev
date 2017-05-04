<?php

/**
 * @file
 * Contains \DrupalProject\build\Phing\AfterFixturesImportCleanup.
 */

namespace DrupalProject\Phing;

/**
 * Class AfterFixturesImportCleanup.
 */
class AfterFixturesImportCleanup extends VirtuosoTaskBase {

  /**
   * Clean up the fixtures after import.
   */
  public function main() {
    // We get our languages from the Metadata Registry. The Metadata Registry
    // maintains two authority tables, one for individual languages and one for
    // groups of languages called multilingual. For legacy reasons the two
    // tables are published as a merger of the two.
    // The multilingual language groups are not useful for us and we need to
    // filter them out to avoid having the language lists polluted with entries
    // labeled 'Multilingual Code'.
    // @see http://publications.europa.eu/mdr/resource//documentation/schema/cat.html#element_languages
    // @see https://webgate.ec.europa.eu/CITnet/jira/browse/ISAICP-2764
    $this->execute('sparql DELETE FROM <http://languages-skos> { ?entity ?field ?value. } WHERE { ?entity ?field ?value . FILTER(isBlank(?entity)) };');

    // The licences are defined in both the adms-sw and the adms-skos files.
    // In adms-sw the version 1.1 is included while the adms-skos has the
    // version 1.0. As a bundle can have only one uri mapped, the 1.0 version
    // has to be removed.
    // @see https://webgate.ec.europa.eu/CITnet/jira/browse/ISAICP-2503
    $this->execute('sparql DELETE FROM <http://adms_skos_v1.00> { ?entity ?field ?value. } WHERE { ?entity ?field ?value . ?entity <http://www.w3.org/2004/02/skos/core#inScheme> <http://purl.org/adms/licencetype/1.0>};');

  }

}
