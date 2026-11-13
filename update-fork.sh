#!/bin/bash
set -e

# Убедимся, что мы точно на ветке main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "⚠️ Вы сейчас на ветке '$CURRENT_BRANCH', а не на 'main'. Переключаемся на main..."
  git checkout main
fi

echo "1. Получаем свежие изменения из upstream..."
git fetch upstream

echo "2. Выполняем rebase main поверх upstream/main..."
# --autostash автоматически спрячет локальные правки (переводы) и вернет их обратно
if git rebase --autostash upstream/main; then
  echo "Rebase прошел успешно!"
else
  echo "⚠️ Возникли конфликты! Разрешите их в файлах, сделайте git add, затем выполните: git rebase --continue"
  exit 1
fi

echo "3. Отправляем обновленный main в ваш форк (origin)..."
git push origin main --force-with-lease

echo "✅ Готово! Ваша main ветка полностью синхронизирована с upstream/main."