<?php

namespace Drupal\collection\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\Routing\RouteMatchInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\og\Og;

/**
 * Provides a block that shows all content within the collection.
 *
 * @Block(
 *  id = "collection_content_block",
 *  admin_label = @Translation("Collection content"),
 * )
 */
class CollectionContentBlock extends BlockBase implements ContainerFactoryPluginInterface {

  /**
   * The collection.
   *
   * @var \Drupal\rdf_entity\RdfInterface
   */
  protected $collection;

  /**
   * The current route match service.
   *
   * @var \Drupal\Core\Routing\RouteMatchInterface
   */
  protected $currentRouteMatch;

  /**
   * The current user.
   *
   * @var \Drupal\Core\Session\AccountProxyInterface $user
   */
  protected $user;

  /**
   * The entity manager, needed to load entities.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  /**
   * Constructs a CollectionContentBlock object.
   *
   * @param array $configuration
   *   A configuration array containing information about the plugin instance.
   * @param string $plugin_id
   *   The plugin ID for the plugin instance.
   * @param string $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Routing\RouteMatchInterface $current_route_match
   *   The current route match service.
   * @param \Drupal\Core\Entity\EntityManagerInterface $entityManager
   *   The entity manager.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, RouteMatchInterface $current_route_match, EntityManagerInterface $entityManager) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->currentRouteMatch = $current_route_match;
    // Retrieve the collection from the route.
    $this->collection = $this->currentRouteMatch->getParameter('rdf_entity');
    $this->entityManager = $entityManager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('current_route_match'),
      $container->get('entity.manager')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    if (empty($this->collection)) {
      // If this is not a collection page, return an empty array so that the
      // block is not rendered.
      return [];
    }
    $content_ids = Og::getGroupContentIds($this->collection);
    $list = array();
    foreach ($content_ids as $entity_type => $ids) {
      $storage = $this->entityManager->getStorage($entity_type);
      $entities = $storage->loadMultiple($ids);
      $children = [];
      foreach ($entities as $entity) {
        $children[] = array('#markup' => $entity->link());
      }
      if ($children) {
        $list[] = array(
          '#markup' => $storage->getEntityType()->getLabel(),
          'children' => $children,
        );
      }
    }
    $build = array(
      'list' => [
        '#theme' => 'item_list',
        '#items' => $list,
        '#cache' => [
          'tags' => ['og_group_content:' . $this->collection->id()],
        ],
      ],
    );
    return $build;
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheMaxAge() {
    // Disable caching.
    return 0;
  }

}
