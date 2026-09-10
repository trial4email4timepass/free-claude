# Skill Catalog

Skills under `.claude/skills/` in this repo, discovered via the [Skillselion](https://skillselion.com/skills) directory (which indexes install counts from GitHub and the skills.sh registry) and pulled directly from each skill's own upstream GitHub repository — never from Skillselion's own copy — for provenance and integrity.

Every skill listed here was reviewed for obviously malicious patterns (piped-curl installers, `eval`/`exec` on remote input, credential exfiltration, destructive `rm -rf`) before being added. None were found. That is not a substitute for reading a skill before you let it act with real tool access — read `SKILL.md` for anything you plan to actually use.

**Total skills:** 133 (135 discovered; 2 skipped as already vendored elsewhere in this repo — see below)  
**Collected:** 2026-09-10

## Sources

| Repo | License | Commit pinned |
|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | Unspecified in repo | `41bbe19d1a1a` |
| [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) | Apache-2.0 | `a156ff576041` |
| [microsoft/azure-skills](https://github.com/microsoft/azure-skills) | MIT | `f5fffa1026f8` |
| [mattpocock/skills](https://github.com/mattpocock/skills) | MIT | `3cca18b368ae` |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Unspecified in repo | `063bee94c3f4` |
| [vercel-labs/skills](https://github.com/vercel-labs/skills) | MIT | `80feb4886897` |
| [larksuite/cli](https://github.com/larksuite/cli) | MIT | `4203560c761b` |
| [remotion-dev/skills](https://github.com/remotion-dev/skills) | Unspecified in repo | `9ae8048a8469` |

## anthropics/skills (17)

`frontend-design` and `skill-creator` are also from this repo but are skipped here — already vendored at the repo root from an earlier PR (see the "Skillselion skill collection" section of `README.md`).

| Skill | Description |
|---|---|
| [`academy-guide`](.claude/skills/academy-guide/SKILL.md) | Stop and check this skill before finishing any reply to a question about how to use Claude or a Claude product — it recommends matching courses, tutorials, a... |
| [`algorithmic-art`](.claude/skills/algorithmic-art/SKILL.md) | Creating algorithmic art using p5.js with seeded randomness and interactive parameter exploration. Use this when users request creating art using code, gener... |
| [`brand-guidelines`](.claude/skills/brand-guidelines/SKILL.md) | Applies Anthropic's official brand colors and typography to any sort of artifact that may benefit from having Anthropic's look-and-feel. Use it when brand co... |
| [`canvas-design`](.claude/skills/canvas-design/SKILL.md) | Create beautiful visual art in .png and .pdf documents using design philosophy. You should use this skill when the user asks to create a poster, piece of art... |
| [`claude-api`](.claude/skills/claude-api/SKILL.md) | Reference for the Claude API / Anthropic SDK — model ids, pricing, params, streaming, tool use, MCP, agents, caching, token counting, model migration. TRIGGE... |
| [`discernment-nudge`](.claude/skills/discernment-nudge/SKILL.md) | After you give a substantive answer or draft that the user may act on — advice or recommendations, drafted artifacts such as goals, plans, pitches, proposals... |
| [`doc-coauthoring`](.claude/skills/doc-coauthoring/SKILL.md) | Guide users through a structured workflow for co-authoring documentation. Use when user wants to write documentation, proposals, technical specs, decision do... |
| [`docx`](.claude/skills/docx/SKILL.md) | Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx files) or Word templates (.dotx files). Triggers include: a... |
| [`internal-comms`](.claude/skills/internal-comms/SKILL.md) | A set of resources to help me write all kinds of internal communications, using the formats that my company likes to use. Claude should use this skill whenev... |
| [`mcp-builder`](.claude/skills/mcp-builder/SKILL.md) | Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use whe... |
| [`pdf`](.claude/skills/pdf/SKILL.md) | Use this skill whenever the user wants to do anything with PDF files. This includes reading or extracting text/tables from PDFs, combining or merging multipl... |
| [`pptx`](.claude/skills/pptx/SKILL.md) | Use this skill any time a .pptx or .potx file is involved in any way — as input, output, or both. This includes: creating slide decks, pitch decks, or presen... |
| [`slack-gif-creator`](.claude/skills/slack-gif-creator/SKILL.md) | Knowledge and utilities for creating animated GIFs optimized for Slack. Provides constraints, validation tools, and animation concepts. Use when users reques... |
| [`theme-factory`](.claude/skills/theme-factory/SKILL.md) | Toolkit for styling artifacts with a theme. These artifacts can be slides, docs, reportings, HTML landing pages, etc. There are 10 pre-set themes with colors... |
| [`web-artifacts-builder`](.claude/skills/web-artifacts-builder/SKILL.md) | Suite of tools for creating elaborate, multi-component claude.ai HTML artifacts using modern frontend web technologies (React, Tailwind CSS, shadcn/ui). Use ... |
| [`webapp-testing`](.claude/skills/webapp-testing/SKILL.md) | Toolkit for interacting with and testing local web applications using Playwright. Supports verifying frontend functionality, debugging UI behavior, capturing... |
| [`xlsx`](.claude/skills/xlsx/SKILL.md) | Use this skill any time a spreadsheet file is the primary input or output. This means any task where the user wants to: open, read, edit, or fix an existing ... |

## vercel-labs/skills (1)

| Skill | Description |
|---|---|
| [`find-skills`](.claude/skills/find-skills/SKILL.md) | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express ... |

## vercel-labs/agent-skills (9)

| Skill | Description |
|---|---|
| [`composition-patterns`](.claude/skills/composition-patterns/SKILL.md) | React composition patterns that scale. Use when refactoring components with boolean prop proliferation, building flexible component libraries, or designing r... |
| [`deploy-to-vercel`](.claude/skills/deploy-to-vercel/SKILL.md) | Deploy applications and websites to Vercel. Use when the user requests deployment actions like "deploy my app", "deploy and give me the link", "push this liv... |
| [`react-best-practices`](.claude/skills/react-best-practices/SKILL.md) | React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.j... |
| [`react-native-skills`](.claude/skills/react-native-skills/SKILL.md) | React Native and Expo best practices for building performant mobile apps. Use when building React Native components, optimizing list performance, implementin... |
| [`react-view-transitions`](.claude/skills/react-view-transitions/SKILL.md) | Guide for implementing smooth, native-feeling animations using React's View Transition API (`<ViewTransition>` component, `addTransitionType`, and CSS view t... |
| [`vercel-cli-with-tokens`](.claude/skills/vercel-cli-with-tokens/SKILL.md) | Deploy and manage projects on Vercel using token-based authentication. Use when working with Vercel CLI using access tokens rather than interactive login — e... |
| [`vercel-optimize`](.claude/skills/vercel-optimize/SKILL.md) | Use for Vercel cost and performance optimization on deployed projects, especially Next.js, SvelteKit, Nuxt, and limited Astro apps. Collect Vercel metrics, u... |
| [`web-design-guidelines`](.claude/skills/web-design-guidelines/SKILL.md) | Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my si... |
| [`writing-guidelines`](.claude/skills/writing-guidelines/SKILL.md) | Review docs/prose for Writing Guidelines compliance. Use when asked to "review my docs", "check writing style", "audit prose", "review docs voice and tone", ... |

## vercel-labs/agent-browser (1)

| Skill | Description |
|---|---|
| [`agent-browser`](.claude/skills/agent-browser/SKILL.md) | Browser automation CLI for AI agents. Use when the user needs to interact with websites, including navigating pages, filling forms, clicking buttons, taking ... |

## mattpocock/skills (37)

| Skill | Description |
|---|---|
| [`ask-matt`](.claude/skills/ask-matt/SKILL.md) | Ask which skill or flow fits your situation. A router over the skills in this repo. |
| [`claude-handoff`](.claude/skills/claude-handoff/SKILL.md) | Hand the current conversation off to a fresh background agent that picks up the work immediately. |
| [`code-review`](.claude/skills/code-review/SKILL.md) | Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow this repo's documented coding sta... |
| [`codebase-design`](.claude/skills/codebase-design/SKILL.md) | Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a... |
| [`diagnosing-bugs`](.claude/skills/diagnosing-bugs/SKILL.md) | Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. |
| [`domain-modeling`](.claude/skills/domain-modeling/SKILL.md) | Build and sharpen a project's domain model. Use when discussing codebase terminology, writing or editing a CONTEXT.md, or recording or editing an ADR. |
| [`git-guardrails-claude-code`](.claude/skills/git-guardrails-claude-code/SKILL.md) | Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent des... |
| [`grill-me`](.claude/skills/grill-me/SKILL.md) | A relentless interview to sharpen a plan or design. |
| [`grill-with-docs`](.claude/skills/grill-with-docs/SKILL.md) | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| [`grilling`](.claude/skills/grilling/SKILL.md) | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| [`handoff`](.claude/skills/handoff/SKILL.md) | Compact the current conversation into a handoff document for another agent to pick up. |
| [`implement`](.claude/skills/implement/SKILL.md) | Implement a piece of work based on a spec or set of tickets. |
| [`implement-spec`](.claude/skills/implement-spec/SKILL.md) | Implement a specification in code. |
| [`improve-codebase-architecture`](.claude/skills/improve-codebase-architecture/SKILL.md) | Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. |
| [`loop-me`](.claude/skills/loop-me/SKILL.md) | Grill me about specs for the workflows I want to build, within this workspace. |
| [`migrate-to-shoehorn`](.claude/skills/migrate-to-shoehorn/SKILL.md) | Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial... |
| [`prototype`](.claude/skills/prototype/SKILL.md) | Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what ... |
| [`research`](.claude/skills/research/SKILL.md) | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched... |
| [`resolving-merge-conflicts`](.claude/skills/resolving-merge-conflicts/SKILL.md) | Use when you need to resolve an in-progress git merge/rebase conflict. |
| [`retro`](.claude/skills/retro/SKILL.md) | Conduct a retrospective on a coding session. |
| [`scaffold-exercises`](.claude/skills/scaffold-exercises/SKILL.md) | Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create ... |
| [`setup-matt-pocock-skills`](.claude/skills/setup-matt-pocock-skills/SKILL.md) | Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the ot... |
| [`setup-pre-commit`](.claude/skills/setup-pre-commit/SKILL.md) | Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up ... |
| [`setup-ts-deep-modules`](.claude/skills/setup-ts-deep-modules/SKILL.md) | Wire dependency-cruiser into a TypeScript repo so each package is a deep module, with implementation hidden in subfolders and reachable only through its entr... |
| [`tdd`](.claude/skills/tdd/SKILL.md) | Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. |
| [`teach`](.claude/skills/teach/SKILL.md) | Teach the user a new skill or concept, within this workspace. |
| [`to-questionnaire`](.claude/skills/to-questionnaire/SKILL.md) | Turn a decision you can't fully answer into a questionnaire for someone else to fill in. |
| [`to-spec`](.claude/skills/to-spec/SKILL.md) | Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed. |
| [`to-tickets`](.claude/skills/to-tickets/SKILL.md) | Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker (... |
| [`triage`](.claude/skills/triage/SKILL.md) | Move issues and external PRs through a state machine of triage roles, categorise, verify, grill if needed, and write agent-ready briefs. |
| [`wait-what`](.claude/skills/wait-what/SKILL.md) | Stop. That last message did not land: re-pitch it. |
| [`wayfinder`](.claude/skills/wayfinder/SKILL.md) | Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time un... |
| [`wizard`](.claude/skills/wizard/SKILL.md) | Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or C... |
| [`writing-beats`](.claude/skills/writing-beats/SKILL.md) | Writing, exploit; assemble raw material into a journey of beats, grounding each term before a beat leans on it. |
| [`writing-for-agents`](.claude/skills/writing-for-agents/SKILL.md) | Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md. |
| [`writing-fragments`](.claude/skills/writing-fragments/SKILL.md) | Writing, explore: mine raw fragments, no structure yet. |
| [`writing-shape`](.claude/skills/writing-shape/SKILL.md) | Writing, exploit: shape raw material into an article, paragraph by paragraph. |

## microsoft/azure-skills (28)

| Skill | Description |
|---|---|
| [`airunway-aks-setup`](.claude/skills/airunway-aks-setup/SKILL.md) | Set up AI Runway on AKS — from bare cluster to running model. Covers cluster verification, controller install, GPU assessment, provider setup, and first depl... |
| [`appinsights-instrumentation`](.claude/skills/appinsights-instrumentation/SKILL.md) | Guidance for instrumenting webapps with Azure Application Insights. Provides telemetry patterns, SDK setup, and configuration references. WHEN: how to instru... |
| [`azure-ai`](.claude/skills/azure-ai/SKILL.md) | Use for Azure AI: Search, Speech, OpenAI, Document Intelligence. Helps with search, vector/hybrid search, speech-to-text, text-to-speech, transcription, OCR.... |
| [`azure-aigateway`](.claude/skills/azure-aigateway/SKILL.md) | Configure Azure API Management as an AI Gateway for AI models, MCP tools, and agents. WHEN: semantic caching, token limit, content safety, load balancing, AI... |
| [`azure-app-onboard`](.claude/skills/azure-app-onboard/SKILL.md) | End-to-end orchestrator: from a business idea, app idea, or existing app to running Azure deployment with cost estimates and pre-deploy approval. Analyzes yo... |
| [`azure-app-onboard-prereq`](.claude/skills/azure-app-onboard-prereq/SKILL.md) | Assess whether source code is ready to deploy to Azure — the check BEFORE infrastructure work. Evaluates build health, app completeness, dependencies and loc... |
| [`azure-cloud-migrate`](.claude/skills/azure-cloud-migrate/SKILL.md) | Assess and migrate cross-cloud workloads to Azure with reports and code conversion. Supports Lambda→Functions, Beanstalk/Heroku/App Engine→App Service, Farga... |
| [`azure-compliance`](.claude/skills/azure-compliance/SKILL.md) | Run Azure compliance and security audits with azqr plus Key Vault expiration checks. Covers best-practice assessment, resource review, policy/compliance vali... |
| [`azure-compute`](.claude/skills/azure-compute/SKILL.md) | Azure VM/VMSS router. WHEN: create / provision / deploy / spin-up VM, recommend VM size, compare VM pricing, VMSS, scale set, autoscale, burstable, lightweig... |
| [`azure-cost`](.claude/skills/azure-cost/SKILL.md) | Azure cost management: query costs, forecast spending, optimize to reduce waste. WHEN: \"Azure costs\", \"Azure bill\", \"cost breakdown\", \"how much am I s... |
| [`azure-deploy`](.claude/skills/azure-deploy/SKILL.md) | Execute Azure deployments for ALREADY-PREPARED applications that have existing .azure/deployment-plan.md and infrastructure files. DO NOT use this skill when... |
| [`azure-diagnostics`](.claude/skills/azure-diagnostics/SKILL.md) | Debug Azure production issues on Azure using AppLens, Azure Monitor, resource health, and safe triage. WHEN: debug production issues, troubleshoot app servic... |
| [`azure-enterprise-infra-planner`](.claude/skills/azure-enterprise-infra-planner/SKILL.md) | Architect and provision enterprise Azure infrastructure from workload descriptions. For cloud architects and platform engineers planning networking, identity... |
| [`azure-kubernetes`](.claude/skills/azure-kubernetes/SKILL.md) | Plan, create, and configure production-ready Azure Kubernetes Service (AKS) clusters. Covers Day-0 checklist, SKU selection (Automatic vs Standard), networki... |
| [`azure-kusto`](.claude/skills/azure-kusto/SKILL.md) | Query and analyze data in Azure Data Explorer (Kusto/ADX) using KQL for log analytics, telemetry, and time series analysis. WHEN: KQL queries, Kusto database... |
| [`azure-messaging`](.claude/skills/azure-messaging/SKILL.md) | Troubleshoot and resolve issues with Azure Messaging SDKs for Event Hubs and Service Bus. Covers connection failures, authentication errors, message processi... |
| [`azure-prepare`](.claude/skills/azure-prepare/SKILL.md) | Prepare azd-based Azure projects for deployment: generates azure.yaml, infrastructure (Bicep/Terraform), and Dockerfiles for the Azure Developer CLI (azd) wo... |
| [`azure-quotas`](.claude/skills/azure-quotas/SKILL.md) | Check/manage Azure quotas and usage across providers. For deployment planning, capacity validation, region selection. WHEN: \"check quotas\", \"service limit... |
| [`azure-reliability`](.claude/skills/azure-reliability/SKILL.md) | Assess and improve the reliability posture of PaaS Applications (Azure Functions and Azure App Service). Scans deployed resources for zone redundancy, ZRS st... |
| [`azure-resource-lookup`](.claude/skills/azure-resource-lookup/SKILL.md) | List, find, and show Azure resources across subscriptions or resource groups. Handles prompts like \"list the websites in my subscription\", \"list my web ap... |
| [`azure-resource-visualizer`](.claude/skills/azure-resource-visualizer/SKILL.md) | Analyze Azure resource groups and generate detailed Mermaid architecture diagrams showing the relationships between individual resources. WHEN: create archit... |
| [`azure-storage`](.claude/skills/azure-storage/SKILL.md) | Azure Storage Services including Blob Storage, File Shares, Queue Storage, Table Storage, and Data Lake. Answers questions about storage access tiers (hot, c... |
| [`azure-upgrade`](.claude/skills/azure-upgrade/SKILL.md) | Assess and upgrade Azure workloads between plans, tiers, or SKUs, or modernize Azure SDK dependencies in source code. WHEN: upgrade Consumption to Flex Consu... |
| [`azure-validate`](.claude/skills/azure-validate/SKILL.md) | Pre-deployment validation for Azure readiness. Run deep checks on configuration, infrastructure (Bicep or Terraform), RBAC role assignments, managed identity... |
| [`entra-agent-id`](.claude/skills/entra-agent-id/SKILL.md) | Provision Microsoft Entra Agent Identity Blueprints, BlueprintPrincipals, and per-instance Agent Identities via Microsoft Graph, and configure OAuth 2.0 toke... |
| [`entra-app-registration`](.claude/skills/entra-app-registration/SKILL.md) | Guides Microsoft Entra ID app registration, OAuth 2.0 authentication, and MSAL integration. USE FOR: create app registration, register Azure AD app, configur... |
| [`microsoft-foundry`](.claude/skills/microsoft-foundry/SKILL.md) | Build, deploy, evaluate, optimize, fine-tune, and manage Microsoft Foundry agents, models, and resources end to end. USE FOR: azd ai agent, azd provision/dep... |
| [`python-appservice-deploy`](.claude/skills/python-appservice-deploy/SKILL.md) | Deploy Python (Flask/Django/FastAPI) code to Azure App Service Linux. WHEN: \"Flask App Service\", \"Django App Service\", \"FastAPI App Service\", \"deploy ... |

## remotion-dev/skills (12)

| Skill | Description |
|---|---|
| [`remotion-best-practices`](.claude/skills/remotion-best-practices/SKILL.md) | Router for all Remotion skills |
| [`remotion-captions`](.claude/skills/remotion-captions/SKILL.md) | Transcribing, displaying and animating captions |
| [`remotion-create`](.claude/skills/remotion-create/SKILL.md) | Create a new Remotion video |
| [`remotion-docs`](.claude/skills/remotion-docs/SKILL.md) | Search Remotion documentation |
| [`remotion-interactivity`](.claude/skills/remotion-interactivity/SKILL.md) | Structure Remotion markup for interactivity |
| [`remotion-maps`](.claude/skills/remotion-maps/SKILL.md) | Remotion Map animation knowledge |
| [`remotion-markup`](.claude/skills/remotion-markup/SKILL.md) | Content, animation and effects best practices |
| [`remotion-multimedia`](.claude/skills/remotion-multimedia/SKILL.md) | Interacting with Mediabunny |
| [`remotion-render`](.claude/skills/remotion-render/SKILL.md) | Export a Remotion video |
| [`remotion-saas`](.claude/skills/remotion-saas/SKILL.md) | Build an app with Remotion |
| [`remotion-studio`](.claude/skills/remotion-studio/SKILL.md) | Preview a Remotion video |
| [`remotion-upgrade`](.claude/skills/remotion-upgrade/SKILL.md) | Upgrade Remotion, and related packages |

## larksuite/cli (28)

| Skill | Description |
|---|---|
| [`lark-approval`](.claude/skills/lark-approval/SKILL.md) | 飞书审批：查询和处理审批待办/已办/实例，搜索可发起审批定义、查看定义详情并发起原生审批实例。当用户要处理审批任务、查看审批实例、搜索或发起审批时使用。审批待办不是飞书任务；非审批类待办走 lark-task。不负责创建审批定义；三方审批定义不走原生提单。 |
| [`lark-apps`](.claude/skills/lark-apps/SKILL.md) | 妙搭（Spark/Miaoda）应用开发与托管：应用创建、本地全栈开发、云端生成迭代、创意设计（UI mockup / 可交互原型 / 线框图 / 落地页 / 仪表盘 / 幻灯片 deck / 视觉探索）、AI相关能力和飞书平台能力或者其他外部能力集成、日志/Trace/监控指标/PV/UV 查询、环境变量管理、... |
| [`lark-attendance`](.claude/skills/lark-attendance/SKILL.md) | 飞书考勤打卡：查询自己的考勤打卡记录 |
| [`lark-base`](.claude/skills/lark-base/SKILL.md) | 飞书多维表格（Base）操作：建表、字段、记录、视图、统计、公式/lookup、表单、仪表盘、应用模式（BaseApp/AppMode 页面与组件）、Workspace 目录、workflow、角色权限、模板中心（多维表格模板分类/列表/搜索）；遇到 Base/多维表格/bitable、BaseApp/AppMo... |
| [`lark-calendar`](.claude/skills/lark-calendar/SKILL.md) | 飞书日历：管理日历日程和会议室。查看/搜索日程、创建/更新日程、管理参会人、查询忙闲和推荐时段、预定会议室。当用户需要查看日程安排、创建/修改会议、查询/预定会议室时使用。不负责：查询过去的视频会议记录（走 lark-meeting）、待办任务（走 lark-task）。 |
| [`lark-contact`](.claude/skills/lark-contact/SKILL.md) | 飞书 / Lark 通讯录:按姓名 / 邮箱解析成 open_id,或按 open_id 反查姓名 / 部门 / 邮箱 / 联系方式 / 个人状态 / 签名,以及按关键词搜索当前用户可见的机器人 / 智能体(agent)。当用户提到一个名字要下一步发消息 / 排日程,或拿到 open_id 想查具体信息时使用。不... |
| [`lark-doc`](.claude/skills/lark-doc/SKILL.md) | 飞书云文档（Docx / Wiki）内容操作：读取、创建、编辑文档，插入或下载图片附件，以及操作思维笔记。用户提供文档 URL/token（包括 doubao.com 的 /docx/、/wiki/）时使用；按 URL 路径/token 而非域名路由。文档内嵌资源按读取参考中的统一规则分流。独立评论操作走 lar... |
| [`lark-drive`](.claude/skills/lark-drive/SKILL.md) | 飞书云空间（云盘/云存储）：管理 Drive 文件和文件夹，包含上传/下载、创建文件夹、复制/移动/删除、查看元数据、查询权限设置、评论/权限/订阅、标题、版本、飞书文档密级标签（secure labels）和本地文件导入。用户需要整理云盘目录、处理云空间资源 URL/token、判断链接类型/真实 token/... |
| [`lark-event`](.claude/skills/lark-event/SKILL.md) | Lark/Feishu real-time event listening / subscribing / consuming: stream events as NDJSON via `lark-cli event consume <EventKey>` (covers IM messages/reaction... |
| [`lark-im`](.claude/skills/lark-im/SKILL.md) | 飞书即时通讯：收发消息和管理群聊。发送和回复消息、搜索聊天记录、管理群聊成员、上传下载图片和文件、管理表情回复、发送应用内/短信/电话加急、发送和处理交互卡片（Interactive Card）、监听卡片按钮回调（card.action.trigger）。当用户需要发消息、查看或搜索聊天记录、下载聊天中的文件、查... |
| [`lark-mail`](.claude/skills/lark-mail/SKILL.md) | 飞书邮箱：Use when user mentions 起草邮件、写邮件、草稿、发送/回复/转发邮件、查阅邮件、看邮件、搜索邮件、邮件文件夹、邮件标签、邮件联系人、监听新邮件、邮件收信规则等；use for mail/email intent only. Do not use for docs/sheets/ca... |
| [`lark-markdown`](.claude/skills/lark-markdown/SKILL.md) | 飞书 Markdown：查看、创建、上传、编辑和比较飞书中的原生 Markdown 文件。当用户要操作飞书 Markdown 文件，或比较其远端版本及本地草稿时使用。纯本地 Markdown 文件操作不触发本 skill。不负责将 Markdown 导入为飞书在线文档，也不负责文件搜索、权限、评论、移动、删除等云... |
| [`lark-meeting`](.claude/skills/lark-meeting/SKILL.md) | 飞书视频会议：查询会议记录与会议产物(纪要/逐字稿/妙记)、妙记搜索/上传/下载/编辑、机器人参与会议；查询进行中的会议、实时会议内容(发言/聊天/共享文档)问答(会上/会里)、发送会中聊天/表情；基于 meeting_id、meeting_no、event_id、note_id、minute_token、vc-... |
| [`lark-minutes`](.claude/skills/lark-minutes/SKILL.md) | 仅当用户或上游配置显式指定 lark-minutes 时使用，相关请求统一交由 lark-meeting 技能处理。 |
| [`lark-note`](.claude/skills/lark-note/SKILL.md) | 仅当用户或上游配置显式指定 lark-note 时使用，相关请求统一交由 lark-meeting 技能处理。 |
| [`lark-okr`](.claude/skills/lark-okr/SKILL.md) | 飞书 OKR：管理目标与关键结果。查看和编辑 OKR 周期、目标、关键结果、对齐关系、量化指标和进展记录。当用户需要查看或创建 OKR、管理目标和关键结果、查看对齐关系时使用。不负责：待办任务管理（lark-task）、日程/会议安排（lark-calendar）、绩效评估 |
| [`lark-openapi-explorer`](.claude/skills/lark-openapi-explorer/SKILL.md) | 飞书/Lark 原生 OpenAPI 探索：从官方文档库中挖掘未经 CLI 封装的原生 OpenAPI 接口。当用户的需求无法被现有 lark-* skill 或 lark-cli 已注册命令满足，需要查找并调用原生飞书 OpenAPI 时使用。 |
| [`lark-shared`](.claude/skills/lark-shared/SKILL.md) | Use for lark-cli setup/auth tasks: auth login/status/logout, user vs bot identity, business-domain permissions (--domain, including all/docs/drive), missing ... |
| [`lark-sheets`](.claude/skills/lark-sheets/SKILL.md) | 飞书电子表格：创建和操作电子表格。支持创建表格、管理工作表与行列结构（增删/合并/调整尺寸/隐藏/冻结）、读写单元格（值/公式/样式/批注/单元格图片）、查找替换、多操作批量更新，以及图表、透视表、条件格式、筛选器、迷你图、浮动图片等对象的创建与维护。当用户需要创建电子表格、管理工作表、批量读写或编辑数据、统计汇... |
| [`lark-skill-maker`](.claude/skills/lark-skill-maker/SKILL.md) | 创建 lark-cli 的自定义 Skill。当用户需要把飞书 API 操作封装成可复用的 Skill（包装原子 API 或编排多步流程）时使用。 |
| [`lark-slides`](.claude/skills/lark-slides/SKILL.md) | 飞书幻灯片：创建和编辑幻灯片。创建演示文稿、读取幻灯片内容、管理幻灯片页面（创建、删除、读取、局部替换）。当用户需要创建或编辑幻灯片、读取或修改单个页面时使用。当用户给出 doubao.com 的 /slides/ URL/token 时，也应直接使用本 skill，不要因为域名不是飞书而回退到 WebFetch... |
| [`lark-task`](.claude/skills/lark-task/SKILL.md) | 飞书任务：管理任务、清单和任务智能体。创建待办任务、查看和更新任务状态、拆分子任务、组织任务清单、分配协作成员、上传任务附件、注册或注销任务智能体、更新任务智能体的主页数据、写入智能体任务记录。当用户需要创建待办事项、查看任务列表、跟踪任务进度、管理项目清单或给他人分配任务、为任务上传附件文件、注册注销任务智能体... |
| [`lark-vc`](.claude/skills/lark-vc/SKILL.md) | 仅当用户或上游配置显式指定 lark-vc 时使用，相关请求统一交由 lark-meeting 技能处理。 |
| [`lark-vc-agent`](.claude/skills/lark-vc-agent/SKILL.md) | 仅当用户或上游配置显式指定 lark-vc-agent 时使用，相关请求统一交由 lark-meeting 技能处理。 |
| [`lark-whiteboard`](.claude/skills/lark-whiteboard/SKILL.md) | 飞书画板：查询和编辑飞书云文档中的画板。支持导出画板为预览图片、导出原始节点结构、使用多种格式更新画板内容。 当用户需要查看画板内容、导出画板图片、编辑画板时使用此 skill。不负责：飞书云文档内容编辑（lark-doc）、文档内嵌电子表格/Base（lark-sheets / lark-base）。 |
| [`lark-wiki`](.claude/skills/lark-wiki/SKILL.md) | 飞书知识库：管理知识空间、空间成员和文档节点。创建和查询知识空间、查看和管理空间成员、管理节点层级结构、在知识库中组织文档和快捷方式。当用户需要在知识库中查找或创建文档、浏览知识空间结构、查看或管理空间成员、移动或复制节点时使用。当用户给出 doubao.com 的 /wiki/ URL/token 时，也应直接... |
| [`lark-workflow-meeting-summary`](.claude/skills/lark-workflow-meeting-summary/SKILL.md) | 会议纪要整理工作流：汇总指定时间范围内的会议纪要并生成结构化报告。当用户需要整理会议纪要、生成会议周报、回顾一段时间内的会议内容时使用。 |
| [`lark-workflow-standup-report`](.claude/skills/lark-workflow-standup-report/SKILL.md) | 日程待办摘要：编排 calendar +agenda 和 task +get-my-tasks，生成指定日期的日程与未完成任务摘要。适用于了解今天/明天/本周的安排。 |

## Not imported

Skillselion also lists many `lark-*` skills authored by `open.feishu.cn` and a handful of skills from small/unverified individual accounts (e.g. `design-taste-frontend`, the `RigorPilot-Skills` set, `hyperframes-registry`). These were skipped: the `open.feishu.cn`-authored Lark listings duplicate the officially-maintained `larksuite/cli` versions already included above, and the individual-author repos didn't have enough of a track record to vet with confidence in this pass. Pull them in on request.
