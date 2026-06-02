import { test, expect } from '@playwright/test';

test('nurse can login but cannot access admin', async ({ page }) => {
    await page.goto('http://localhost:3001');

    await page
        .getByRole('textbox', { name: 'Email', exact: true })
        .fill('student@exam.com');

    await page
        .getByRole('textbox', { name: 'Password', exact: true })
        .fill('password');

    await page
        .getByRole('button', { name: 'Login', exact: true })
        .click();

    await page
        .getByRole('button', { name: 'Admin', exact: true })
        .click();

    await expect(
        page.getByText('Du har ikke adminrettigheder.')
    ).toBeVisible();
});
