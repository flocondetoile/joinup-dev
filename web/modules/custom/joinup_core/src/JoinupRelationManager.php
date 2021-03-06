<?php

namespace Drupal\joinup_core;

use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Drupal\Core\Entity\EntityInterface;
use Drupal\og\MembershipManagerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Service to manage relations for the group content entities.
 */
class JoinupRelationManager implements ContainerInjectionInterface {

  /**
   * The OG membership manager service.
   *
   * @var \Drupal\og\MembershipManagerInterface
   */
  protected $membershipManager;

  /**
   * Constructs a JoinupRelationshipManager object.
   *
   * @param \Drupal\og\MembershipManagerInterface $membershipManager
   *   The OG membership manager service.
   */
  public function __construct(MembershipManagerInterface $membershipManager) {
    $this->membershipManager = $membershipManager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('og.membership_manager')
    );
  }

  /**
   * Retrieves the parent of the entity.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The group content entity.
   *
   * @return \Drupal\rdf_entity\RdfInterface|null
   *   The rdf entity the passed entity belongs to, or NULL when no group is
   *    found.
   */
  public function getParent(EntityInterface $entity) {
    $groups = $this->membershipManager->getGroups($entity);
    if (empty($groups['rdf_entity'])) {
      return NULL;
    }

    return reset($groups['rdf_entity']);
  }

  /**
   * Retrieves the moderation state of the parent.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The group content entity.
   *
   * @return int
   *   The moderation status.
   *
   * @throws \Drupal\joinup_core\Exception\MissingRelationException
   *   Thrown when the entity doesn't have a parent.
   */
  public function getParentModeration(EntityInterface $entity) {
    $parent = $this->getParent($entity);
    if (!$parent) {
      return NULL;
    }
    $field_array = [
      'collection' => 'field_ar_moderation',
      'solution' => 'field_is_moderation',
    ];

    $moderation = $parent->{$field_array[$parent->bundle()]}->value;
    return $moderation;
  }

  /**
   * Retrieves the state of the parent.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The group content entity.
   *
   * @return string
   *   The state of the parent entity.
   */
  public function getParentState(EntityInterface $entity) {
    $parent = $this->getParent($entity);
    $field_array = [
      'collection' => 'field_ar_state',
      'solution' => 'field_is_state',
    ];

    $state = $parent->{$field_array[$parent->bundle()]}->first()->value;
    return $state;
  }

  /**
   * Retrieves the eLibrary settings of the parent.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The group content entity.
   *
   * @return string
   *   The state of the parent entity.
   */
  public function getParentElibrary(EntityInterface $entity) {
    $parent = $this->getParent($entity);
    $field_array = [
      'collection' => 'field_ar_elibrary_creation',
      'solution' => 'field_is_elibrary_creation',
    ];

    $e_library = $parent->{$field_array[$parent->bundle()]}->first()->value;
    return $e_library;
  }

}
