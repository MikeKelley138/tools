<?php
// functions.php or your blocks loader

class ACF_Blocks_Dynamic_Assets {
    
    public function __construct() {
        add_action('init', [$this, 'register_blocks']);
        add_action('wp_enqueue_scripts', [$this, 'enqueue_block_assets']);
        add_action('enqueue_block_editor_assets', [$this, 'enqueue_editor_assets']);
    }
    
    public function register_blocks() {
        $blocks = [
            'block1',
            'block2',
            'block3'
            // Add all your block names
        ];
        
        foreach ($blocks as $block) {
            register_block_type(
                get_stylesheet_directory() . "/blocks/{$block}/block.json",
                [
                    'render_callback' => [$this, 'render_block_with_assets'],
                ]
            );
        }
    }
    
    public function render_block_with_assets($block_attributes, $content, $wp_block) {
        $block_name = $wp_block->name ?? '';
        $block_slug = str_replace('acf/', '', $block_name);
        
        // Enqueue frontend assets for this specific block
        $this->enqueue_block_assets_dynamically($block_slug);
        
        // Render the block
        $block_path = get_stylesheet_directory() . "/blocks/{$block_slug}/render.php";
        if (file_exists($block_path)) {
            ob_start();
            include $block_path;
            return ob_get_clean();
        }
        
        return $content;
    }
    
    public function enqueue_block_assets_dynamically($block_slug) {
        $block_path = get_stylesheet_directory() . "/blocks/{$block_slug}";
        $dist_path = $block_path . '/dist/';
        
        // Enqueue frontend CSS if exists
        if (file_exists($dist_path . 'style.css')) {
            wp_enqueue_style(
                "acf-{$block_slug}-style",
                get_stylesheet_directory_uri() . "/blocks/{$block_slug}/dist/style.css",
                [],
                filemtime($dist_path . 'style.css')
            );
        }
        
        // Enqueue frontend JS if exists
        if (file_exists($dist_path . 'script.js')) {
            wp_enqueue_script(
                "acf-{$block_slug}-script",
                get_stylesheet_directory_uri() . "/blocks/{$block_slug}/dist/script.js",
                [],
                filemtime($dist_path . 'script.js'),
                true
            );
        }
    }
    
    public function enqueue_editor_assets() {
        // Editor assets are enqueued globally in admin
        $blocks_dir = get_stylesheet_directory() . '/blocks/';
        
        if (!file_exists($blocks_dir)) return;
        
        $block_folders = scandir($blocks_dir);
        
        foreach ($block_folders as $block) {
            if (in_array($block, ['.', '..'])) continue;
            
            $dist_path = $blocks_dir . $block . '/dist/';
            
            // Editor CSS
            if (file_exists($dist_path . 'editor.css')) {
                wp_enqueue_style(
                    "acf-{$block}-editor",
                    get_stylesheet_directory_uri() . "/blocks/{$block}/dist/editor.css",
                    ['wp-edit-blocks'],
                    filemtime($dist_path . 'editor.css')
                );
            }
            
            // Editor JS
            if (file_exists($dist_path . 'index.js')) {
                wp_enqueue_script(
                    "acf-{$block}-editor",
                    get_stylesheet_directory_uri() . "/blocks/{$block}/dist/index.js",
                    ['wp-blocks', 'wp-element', 'wp-editor', 'wp-components'],
                    filemtime($dist_path . 'index.js'),
                    true
                );
            }
        }
    }
    
    // Fallback for traditional enqueuing
    public function enqueue_block_assets() {
        // This can remain empty or handle global block assets
    }
}

new ACF_Blocks_Dynamic_Assets();
