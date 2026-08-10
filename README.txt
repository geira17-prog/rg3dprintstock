RG3DPrint Stock v2 — Supabase

1. Crie um projeto Supabase gratuito.
2. No SQL Editor execute o ficheiro supabase.sql.
3. Em Authentication > Providers deixe Email ativo.
4. Copie o Project URL e a chave pública/publishable.
5. Faça uma cópia de config.example.js chamada config.js e preencha esses dois valores.
6. Publique todos os ficheiros num alojamento HTTPS (GitHub Pages é uma opção).
7. Abra o endereço no Android Chrome e escolha Instalar aplicação/Adicionar ao ecrã principal.

IMPORTANTE:
- Nunca coloque a service_role key no código do navegador.
- Esta versão usa autenticação por email/password.
- Fotos são guardadas como data URL na base de dados nesta primeira versão. Para muitas fotos, recomenda-se migrar depois para Supabase Storage.
