<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class FallbackController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'fallback';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchFallbackAction()
    {
        return $this->searchBase('fallback.fallback', array('enabled', 'name', 'primary', 'secondary', 'threshold', 'always_standby'));
    }

    public function getFallbackAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('fallback', 'fallback.fallback', $uuid);
    }

    public function addFallbackAction()
    {
        return $this->addBase('fallback', 'fallback.fallback');
    }

    public function delFallbackAction($uuid)
    {
        return $this->delBase('fallback.fallback', $uuid);
    }

    public function setFallbackAction($uuid)
    {
        return $this->setBase('fallback', 'fallback.fallback', $uuid);
    }

    public function toggleFallbackAction($uuid)
    {
        return $this->toggleBase('fallback.fallback', $uuid);
    }

    // Generic Item methods for frontend compatibility
    public function searchItemAction()
    {
        return $this->searchFallbackAction();
    }

    public function getItemAction($uuid = null)
    {
        return $this->getFallbackAction($uuid);
    }

    public function addItemAction()
    {
        return $this->addFallbackAction();
    }

    public function delItemAction($uuid)
    {
        return $this->delFallbackAction($uuid);
    }

    public function setItemAction($uuid)
    {
        return $this->setFallbackAction($uuid);
    }

    public function toggleItemAction($uuid)
    {
        return $this->toggleFallbackAction($uuid);
    }
}