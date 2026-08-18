<template>
  <div class="pre-footer-links">
    <div class="pre-footer-links__divider" />
    <div class="pre-footer-links__content">
      <a
        class="pre-footer-links__item"
        href="https://water.usgs.gov/vizlab/"
        target="_blank"
        rel="noopener noreferrer"
      >
        See more <span v-if="!mobileView">visualizations</span> from the USGS Vizlab
      </a>
      <a
        class="pre-footer-links__item"
        :href="gitHubRepositoryLink"
        target="_blank"
        rel="noopener noreferrer"
      >
        Get the code behind this page
        <font-awesome-icon
          :icon="{ prefix: 'fab', iconName: 'github' }"
          aria-hidden="true"
        />
      </a>
    </div>
  </div>
</template>

<script setup>
  import { isMobileOnly } from 'mobile-device-detect';

  // global variables
  const mobileView = isMobileOnly;

  const gitHubRepositoryLink = import.meta.env.VITE_APP_GITHUB_REPOSITORY_LINK;
</script>

<style scoped lang="scss">
.pre-footer-links {
  background-color: white;
  /* no horizontal padding here - the inner boxes own it, so they can line up
     with the .page-section text column above (max-width 1200px, padding 1em,
     where 1em is the body font-size of 2rem / 1.6rem on mobile) */
  padding: 1.5rem 0 2rem;
  font-family: 'Noto Sans', sans-serif;
  font-size: 1.5rem;
  color: #1e1e1e;

  &__divider {
    border-top: 1px solid #d4d8dd;
    margin: 0 auto 1.5rem;
    width: calc(100% - 4rem);
    max-width: calc(1200px - 4rem);
  }

  &__content {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
    width: calc(100% - 4rem);
    max-width: calc(1200px - 4rem);
    margin: 0 auto;
  }

  @media screen and (max-width: 600px) {
    &__divider,
    &__content {
      width: calc(100% - 3.2rem);
    }
  }

  &__item {
    color: inherit;
    text-decoration: none;
    font-weight: 600;
    letter-spacing: 0.01em;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    background-image: linear-gradient(var(--color-prefooter-highlight), var(--color-prefooter-highlight));
    background-position: 0 100%;
    background-repeat: no-repeat;
    background-size: 100% 0.2rem;
    padding-bottom: 0.1rem;
    transition: color 0.2s ease-in-out;

    &:hover,
    &:focus-visible {
      color: var(--color-prefooter-highlight);
    }
  }
}

@media (min-width: 640px) {
  .pre-footer-links {
    &__content {
      flex-direction: row;
      justify-content: space-between;
      align-items: center;
    }
  }
}
</style>
