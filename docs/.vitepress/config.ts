import { defineConfig } from 'vitepress'

const repo = 'https://github.com/Sunwood-ai-labs/hermes-agent-pod'

export default defineConfig({
  title: 'Hermes Agent Pod',
  description: 'Run Nous Research Hermes Agent locally as a Kubernetes Pod or Docker Compose service.',
  base: '/hermes-agent-pod/',
  cleanUrls: true,
  head: [
    ['link', { rel: 'icon', href: '/hermes-agent-pod/hermes-agent-pod-icon.svg', type: 'image/svg+xml' }],
    ['meta', { property: 'og:title', content: 'Hermes Agent Pod' }],
    ['meta', { property: 'og:description', content: 'Local Hermes Agent gateway, dashboard, and Codex worker wrapper for kind and Docker Compose.' }]
  ],
  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      title: 'Hermes Agent Pod',
      description: 'Local Hermes Agent gateway and worker wrapper for kind or Docker Compose.',
      themeConfig: {
        nav: [
          { text: 'Guide', link: '/guide/getting-started' },
          { text: 'GitHub', link: repo }
        ],
        sidebar: [
          {
            text: 'Guide',
            items: [
              { text: 'Getting Started', link: '/guide/getting-started' },
              { text: 'Usage', link: '/guide/usage' },
              { text: 'Architecture', link: '/guide/architecture' },
              { text: 'Troubleshooting', link: '/guide/troubleshooting' }
            ]
          }
        ]
      }
    },
    ja: {
      label: '日本語',
      lang: 'ja-JP',
      title: 'Hermes Agent Pod',
      description: 'kind または Docker Compose で動かすローカル Hermes Agent gateway。',
      themeConfig: {
        nav: [
          { text: 'ガイド', link: '/ja/guide/getting-started' },
          { text: 'GitHub', link: repo }
        ],
        sidebar: [
          {
            text: 'ガイド',
            items: [
              { text: 'はじめに', link: '/ja/guide/getting-started' },
              { text: '使い方', link: '/ja/guide/usage' },
              { text: '構成', link: '/ja/guide/architecture' },
              { text: 'トラブルシュート', link: '/ja/guide/troubleshooting' }
            ]
          }
        ]
      }
    }
  },
  themeConfig: {
    logo: '/hermes-agent-pod-icon.svg',
    search: {
      provider: 'local'
    },
    socialLinks: [
      { icon: 'github', link: repo }
    ],
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright (c) 2026 Sunwood-ai-labs'
    }
  }
})
