# `authentik` module options

<ul>
<li>
  <b><u><code>authentik.applications</code></u></b><br>
  <b>type</b>: <code>attribute set of (submodule)</code><br>
  <b>default</b>: <pre>&#34;{ }&#34;</pre><br>
  <b>example</b>: <pre>{&#34;text&#34;:&#34;authentik.applications = {\n  grafana = {\n    group = \&#34;Monitoring\&#34;;\n    description = \&#34;Grafana monitoring dashboard\&#34;;\n    icon = \&#34;https://example.com/grafana.png\&#34;;\n    accessGroups = [\&#34;admins\&#34; \&#34;monitoring-users\&#34;];\n\n    # OAuth2 provider configuration\n    oauth2 = {\n      clientId = \&#34;grafana\&#34;;\n      clientSecret = \&#34;supersecret\&#34;;\n      redirectUris = [\n        { url = \&#34;https://grafana.example.com/login/generic_oauth\&#34;; }\n      ];\n      launchUrl = \&#34;https://grafana.example.com\&#34;;\n    };\n\n    # Entitlements for in-app permissions\n    entitlements = [\n      {\n        name = \&#34;Grafana Admin\&#34;;\n        groups = [\&#34;grafana-admins\&#34;];\n      }\n      {\n        name = \&#34;Grafana Editor\&#34;;\n        groups = [\&#34;grafana-editors\&#34;];\n      }\n    ];\n  };\n\n  wiki = {\n    name = \&#34;Internal Wiki\&#34;;\n    group = \&#34;Documentation\&#34;;\n    description = \&#34;Company documentation\&#34;;\n    icon = \&#34;https://example.com/wiki.png\&#34;;\n    accessGroups = [\&#34;employees\&#34;];\n\n    # Proxy provider configuration\n    proxy = {\n      externalHost = \&#34;https://wiki.example.com\&#34;;\n      basicAuth = {\n        enable = true;\n        username = \&#34;email\&#34;;\n        password = \&#34;uid\&#34;;\n      };\n    };\n  };\n};\n&#34;}</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Configuration for Authentik applications to be managed by Terranix.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.accessGroups</code></u></b><br>
  <b>type</b>: <code>list of string</code><br>
  <b>default</b>: <pre>&#34;[ ]&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Groups that can access this application<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.description</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: A description of the application<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.enable</code></u></b><br>
  <b>type</b>: <code>boolean</code><br>
  <b>default</b>: <pre>&#34;true&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Whether to enable this Authentik application definition.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.entitlements</code></u></b><br>
  <b>type</b>: <code>list of (submodule)</code><br>
  <b>default</b>: <pre>&#34;[ ]&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Entitlements for in-application permissions<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.entitlements.*.groups</code></u></b><br>
  <b>type</b>: <code>list of string</code><br>
  <b>default</b>: <pre>&#34;[ ]&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Groups that have this entitlement<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.entitlements.*.name</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: The name of the entitlement<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.extraConfig</code></u></b><br>
  <b>type</b>: <code>JSON value</code><br>
  <b>default</b>: <pre>&#34;{ }&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Extra attributes to pass directly to the authentik_application resource.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.group</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: The group this application belongs to in the UI<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.icon</code></u></b><br>
  <b>type</b>: <code>null or string</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: URL or path to the application icon<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.ldap</code></u></b><br>
  <b>type</b>: <code>null or (submodule)</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: LDAP provider configuration<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.ldap.baseDn</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Base DN for LDAP searches<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.ldap.bindMode</code></u></b><br>
  <b>type</b>: <code>one of &#34;direct&#34;, &#34;cached&#34;</code><br>
  <b>default</b>: <pre>&#34;\&#34;cached\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: LDAP bind mode<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.ldap.searchMode</code></u></b><br>
  <b>type</b>: <code>one of &#34;direct&#34;, &#34;cached&#34;</code><br>
  <b>default</b>: <pre>&#34;\&#34;cached\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: LDAP search mode<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.ldap.tlsServerName</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: TLS server name for LDAP<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.name</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;‹name›\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Display name of the application in Authentik.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2</code></u></b><br>
  <b>type</b>: <code>null or (submodule)</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: OAuth2 provider configuration<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.backchannelLdap</code></u></b><br>
  <b>type</b>: <code>null or (submodule)</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: LDAP configuration for backchannel authentication<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.backchannelLdap.baseDn</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Base DN for LDAP searches<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.backchannelLdap.bindMode</code></u></b><br>
  <b>type</b>: <code>one of &#34;direct&#34;, &#34;cached&#34;</code><br>
  <b>default</b>: <pre>&#34;\&#34;cached\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: LDAP bind mode<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.backchannelLdap.searchMode</code></u></b><br>
  <b>type</b>: <code>one of &#34;direct&#34;, &#34;cached&#34;</code><br>
  <b>default</b>: <pre>&#34;\&#34;cached\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: LDAP search mode<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.backchannelLdap.tlsServerName</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: TLS server name for LDAP<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.clientId</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: OAuth2 client ID<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.clientSecret</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: OAuth2 client secret<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.launchUrl</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: URL to launch the application<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.redirectUris</code></u></b><br>
  <b>type</b>: <code>list of (submodule)</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: List of allowed redirect URIs<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.redirectUris.*.matchingMode</code></u></b><br>
  <b>type</b>: <code>one of &#34;strict&#34;, &#34;startsWith&#34;</code><br>
  <b>default</b>: <pre>&#34;\&#34;strict\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: URI matching mode<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.oauth2.redirectUris.*.url</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Redirect URI<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.openInNewTab</code></u></b><br>
  <b>type</b>: <code>boolean</code><br>
  <b>default</b>: <pre>&#34;true&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Specifies if the application should be opened in a new tab.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.policyEngineMode</code></u></b><br>
  <b>type</b>: <code>one of &#34;any&#34;, &#34;all&#34;</code><br>
  <b>default</b>: <pre>&#34;\&#34;any\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Policy engine mode.
- &#34;any&#34;: Pass if any policy passes.
- &#34;all&#34;: Pass if all policies pass.
<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.protocolProvider</code></u></b><br>
  <b>type</b>: <code>null or string</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Reference to an existing provider. Use this only if you&#39;re not using the built-in provider options.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.proxy</code></u></b><br>
  <b>type</b>: <code>null or (submodule)</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Proxy provider configuration<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.proxy.basicAuth.enable</code></u></b><br>
  <b>type</b>: <code>boolean</code><br>
  <b>default</b>: <pre>&#34;false&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Enable passing basic authentication to the proxied application<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.proxy.basicAuth.password</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;password\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: User/group attribute to use for password<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.proxy.basicAuth.username</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;username\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: User/group attribute to use for username<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.proxy.externalHost</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: External host URL for the proxy<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.slug</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;‹name›\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Internal slug for the application (e.g., for URLs). Defaults to the application&#39;s attribute name.<br>
</li>
<li>
  <b><u><code>authentik.applications.&lt;name&gt;.tfResourceName</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;‹name›\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/applications.nix">module/applications.nix</a><br>
  <b>description</b>: Explicitly set the Terraform resource name. Defaults to the application&#39;s attribute name.<br>
</li>
<li>
  <b><u><code>authentik.headers</code></u></b><br>
  <b>type</b>: <code>attribute set of string</code><br>
  <b>default</b>: <pre>&#34;{ }&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule">module</a><br>
  <b>description</b>: Additional headers to send with requests to Authentik.<br>
</li>
<li>
  <b><u><code>authentik.host</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>null</pre><br>
  <b>example</b>: <pre>{&#34;text&#34;:&#34;\&#34;https://auth.example.com/\&#34;&#34;}</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule">module</a><br>
  <b>description</b>: The URL of your Authentik instance<br>
</li>
<li>
  <b><u><code>authentik.insecure</code></u></b><br>
  <b>type</b>: <code>boolean</code><br>
  <b>default</b>: <pre>&#34;false&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule">module</a><br>
  <b>description</b>: Whether to allow insecure connections to Authentik.<br>
</li>
<li>
  <b><u><code>authentik.outpostSettings</code></u></b><br>
  <b>type</b>: <code>JSON value</code><br>
  <b>default</b>: <pre>&#34;{ }&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: Global configuration to apply to all outposts<br>
</li>
<li>
  <b><u><code>authentik.outposts.ldap.config</code></u></b><br>
  <b>type</b>: <code>attribute set</code><br>
  <b>default</b>: <pre>&#34;{ }&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: Additional configuration for the LDAP outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.ldap.enable</code></u></b><br>
  <b>type</b>: <code>boolean</code><br>
  <b>default</b>: <pre>&#34;false&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: Whether to enable the LDAP outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.ldap.name</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;LDAP Outpost\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: The name of the LDAP outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.ldap.providers</code></u></b><br>
  <b>type</b>: <code>list of string</code><br>
  <b>default</b>: <pre>&#34;[ ]&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: List of LDAP provider IDs<br>
</li>
<li>
  <b><u><code>authentik.outposts.ldap.tfResourceName</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;ldap\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: The Terraform resource name for the LDAP outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.proxy.name</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;authentik Embedded Outpost\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: The name of the Proxy outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.proxy.providers</code></u></b><br>
  <b>type</b>: <code>list of string</code><br>
  <b>default</b>: <pre>&#34;[ ]&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: List of proxy provider IDs for the embedded outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.proxy.tfResourceName</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;embedded-outpost\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: The Terraform resource name for the embedded outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.radius.config</code></u></b><br>
  <b>type</b>: <code>attribute set</code><br>
  <b>default</b>: <pre>&#34;{ }&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: Additional configuration for the RADIUS outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.radius.enable</code></u></b><br>
  <b>type</b>: <code>boolean</code><br>
  <b>default</b>: <pre>&#34;false&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: Whether to enable the RADIUS outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.radius.name</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;RADIUS Outpost\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: The name of the RADIUS outpost<br>
</li>
<li>
  <b><u><code>authentik.outposts.radius.providers</code></u></b><br>
  <b>type</b>: <code>list of string</code><br>
  <b>default</b>: <pre>&#34;[ ]&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: List of RADIUS provider IDs<br>
</li>
<li>
  <b><u><code>authentik.outposts.radius.tfResourceName</code></u></b><br>
  <b>type</b>: <code>string</code><br>
  <b>default</b>: <pre>&#34;\&#34;radius\&#34;&#34;</pre><br>
  <b>example</b>: <pre>null</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule/outposts.nix">module/outposts.nix</a><br>
  <b>description</b>: The Terraform resource name for the RADIUS outpost<br>
</li>
<li>
  <b><u><code>authentik.token</code></u></b><br>
  <b>type</b>: <code>null or string</code><br>
  <b>default</b>: <pre>&#34;null&#34;</pre><br>
  <b>example</b>: <pre>{&#34;text&#34;:&#34;\&#34;your_token_here\&#34;&#34;}</pre><br>
  <b>defined</b>: <a href="https://github.com/synapdeck/terranix-authentik/tree/main/modulemodule">module</a><br>
  <b>description</b>: The token for your Authentik instance, or null to use the AUTHENTIK_TOKEN variable.<br>
</li>
</ul>
