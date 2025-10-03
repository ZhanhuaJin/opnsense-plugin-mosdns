<?php

namespace OPNsense\MosDNS;

use OPNsense\Base\IndexController as BaseIndexController;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class IndexController extends BaseIndexController
{
    public function indexAction()
    {
        $this->view->pick('OPNsense/MosDNS/index');
        
        // 加载所有需要的表单
        $this->view->generalForm = $this->getForm('general');
        $this->view->pluginsCacheForm = $this->getForm('pluginsCache');
        $this->view->pluginsFallbackForm = $this->getForm('pluginsFallback');
        $this->view->pluginsForwardForm = $this->getForm('pluginsForward');
        $this->view->pluginsHostsForm = $this->getForm('pluginsHosts');
        $this->view->pluginsIpsetForm = $this->getForm('pluginsIPSet');
        $this->view->pluginsRedirectForm = $this->getForm('pluginsRedirect');
        $this->view->pluginsSequenceForm = $this->getForm('pluginsSequence');
        $this->view->pluginsServersForm = $this->getForm('pluginsServers');
        $this->view->externalDataForm = $this->getForm('externaldata');
    }
}